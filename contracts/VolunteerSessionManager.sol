// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract VolunteerSessionManager is ERC721URIStorage {
    struct VolunteerSession {
        string userId;
        string username;
        uint256 volunteerHours;
        string date;
        string volunteerType;
        address userAddress;
    }

    struct Certificate {
        string certificateId; // UUID
        string userId;        // 사용자 ID
        string username;      // 사용자 이름
        uint256 totalHours;   // 총 봉사 시간
        string issueDate;     // 발급일
    }


    mapping(uint256 => VolunteerSession) public volunteerSessions;
    mapping(string => uint256[]) public userSessions; // userId에 해당하는 세션 목록을 저장하는 mapping
    mapping(string => Certificate) public certificates; // certificateId => Certificate
    mapping(string => string) public userToCertificate; // userId => certificateId

    uint256 public sessionCounter;

    // 상태 변수 이름 변경
    mapping(string => bool) public userCertificateStatus; // userId => 자격증 발급 여부

    // 상태 변수 참조를 위한 함수 이름 변경
    function hasUserCertificate(string memory userId) public view returns (bool) {
        return userCertificateStatus[userId];
    }


    // ERC-721을 위한 이벤트
    event VolunteerSessionCreated(
        uint256 indexed sessionId,
        string userId,
        string username,
        uint256 volunteerHours,
        string date,
        string volunteerType,
        address userAddress
    );

    event CertificateIssued(
        string certificateId,
        string userId,
        string username,
        uint256 totalHours,
        string issueDate
    );

    constructor() ERC721("Volunteer NFT", "VNFT") {}

    function createVolunteerSession(
        string memory _userId,
        string memory _username,
        uint256 _volunteerHours,
        string memory _date,
        string memory _volunteerType,
        address _userAddress
    ) public returns (uint256) {
        sessionCounter++;

        // 봉사 세션을 저장
        volunteerSessions[sessionCounter] = VolunteerSession(
            _userId,
            _username,
            _volunteerHours,
            _date,
            _volunteerType,
            _userAddress
        );
        userSessions[_userId].push(sessionCounter); // userId에 해당하는 세션 ID를 저장

        // NFT 발행
        uint256 tokenId = sessionCounter;
        _safeMint(_userAddress, tokenId); // 봉사자 주소에 NFT 발행
        _setTokenURI(tokenId, generateTokenURI(_userId, _username, _volunteerHours, _date, _volunteerType)); // 메타데이터 설정

        emit VolunteerSessionCreated(
            sessionCounter,
            _userId,
            _username,
            _volunteerHours,
            _date,
            _volunteerType,
            _userAddress
        );

        return tokenId; // 발행된 NFT의 토큰 ID 반환
    }


// 자격증 발급 후 저장 여부를 확인하는 로그
function issueCertificate(
    string memory certificateId,
    string memory userId,
    string memory username,
    string memory issueDate
) public returns (
    string memory returnedCertificateId,
    string memory returnedUserId,
    string memory returnedUsername,
    uint256 totalHours,
    string memory returnedIssueDate
) {
    uint256 volunteerHours = calculateTotalVolunteerHours(userId);

    // 봉사 시간이 부족한 경우
    require(volunteerHours >= 80);

    // 이미 자격증이 발급된 경우
    require(!userCertificateStatus[userId]);

    // 자격증 발급
    certificates[certificateId] = Certificate({
        certificateId: certificateId,
        userId: userId,
        username: username,
        totalHours: volunteerHours,
        issueDate: issueDate
    });

    userCertificateStatus[userId] = true;
    userToCertificate[userId] = certificateId;
    // 확인: 저장된 자격증 데이터를 출력
    Certificate memory savedCert = certificates[certificateId];
//    require(bytes(savedCert.certificateId).length > 0, "Certificate was not saved properly");
    emit CertificateIssued(savedCert.certificateId, savedCert.userId, savedCert.username, savedCert.totalHours, savedCert.issueDate);

    // 성공적으로 발급된 자격증 정보를 반환
    return (certificateId, userId, username, volunteerHours, issueDate);
}





    function calculateTotalVolunteerHours(string memory userId) public view returns (uint256) {
        uint256 totalHours = 0;
        uint256[] memory sessions = userSessions[userId];

        for (uint256 i = 0; i < sessions.length; i++) {
            totalHours += volunteerSessions[sessions[i]].volunteerHours;
        }

        return totalHours;
    }

    function getCertificateById(string memory inputCertificateId)
        public
        view
        returns (
            string memory certificateId,
            string memory userId,
            string memory username,
            uint256 totalHours,
            string memory issueDate
        ) {
        require(bytes(certificates[inputCertificateId].certificateId).length > 0, "Certificate not found");
        Certificate memory cert = certificates[inputCertificateId];
        return (cert.certificateId, cert.userId, cert.username, cert.totalHours, cert.issueDate);
    }


    function generateTokenURI(
        string memory _userId,
        string memory _username,
        uint256 _volunteerHours,
        string memory _date,
        string memory _volunteerType
    ) internal pure returns (string memory) {
        // NFT 메타데이터 생성: 봉사자 정보와 봉사 기록을 포함한 JSON 형태로 반환
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                base64encode(
                    abi.encodePacked(
                        '{"userId": "', _userId, '",',
                        '"username": "', _username, '",',
                        '"volunteerHours": "', uint2str(_volunteerHours), '",',
                        '"date": "', _date, '",',
                        '"volunteerType": "', _volunteerType, '"}'
                    )
                )
            )
        );
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

    // Base64 인코딩 함수 (metadadata를 Base64로 인코딩하기 위해 필요)
    function base64encode(bytes memory data) internal pure returns (string memory) {
        string memory table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        uint256 encodeLen = (data.length + 2) / 3 * 4;
        string memory result = new string(encodeLen);
        bytes memory tableBytes = bytes(table);
        uint256 i = 0;
        uint256 j = 0;

        for (; i < data.length;) {
            uint256 input = uint256(uint8(data[i++])) << 16;
            if (i < data.length) {
                input |= uint256(uint8(data[i++])) << 8;
            }
            if (i < data.length) {
                input |= uint256(uint8(data[i++]));
            }
            result = string(abi.encodePacked(result, tableBytes[input >> 18 & 0x3F], tableBytes[input >> 12 & 0x3F], tableBytes[input >> 6 & 0x3F], tableBytes[input & 0x3F]));
        }

        return result;
    }

    function getVolunteerSession(uint256 _sessionId) public view returns (VolunteerSession memory) {
        return volunteerSessions[_sessionId];
    }

    function getVolunteerSessionsByUserId(string memory _userId)
        public
        view
        returns (
            string[] memory userIds,
            string[] memory usernames,
            uint256[] memory volunteerHours,
            string[] memory dates,
            string[] memory volunteerTypes,
            address[] memory userAddresses
        )
    {
        uint256 count = 0;
        for (uint256 i = 1; i <= sessionCounter; i++) {
            if (keccak256(abi.encodePacked(volunteerSessions[i].userId)) == keccak256(abi.encodePacked(_userId))) {
                count++;
            }
        }

        // 각 필드의 배열 생성
        string[] memory _userIds = new string[](count);
        string[] memory _usernames = new string[](count);
        uint256[] memory _volunteerHours = new uint256[](count);
        string[] memory _dates = new string[](count);
        string[] memory _volunteerTypes = new string[](count);
        address[] memory _userAddresses = new address[](count);

        uint256 index = 0;
        for (uint256 i = 1; i <= sessionCounter; i++) {
            if (keccak256(abi.encodePacked(volunteerSessions[i].userId)) == keccak256(abi.encodePacked(_userId))) {
                VolunteerSession memory session = volunteerSessions[i];
                _userIds[index] = session.userId;
                _usernames[index] = session.username;
                _volunteerHours[index] = session.volunteerHours;
                _dates[index] = session.date;
                _volunteerTypes[index] = session.volunteerType;
                _userAddresses[index] = session.userAddress;
                index++;
            }
        }

        return (_userIds, _usernames, _volunteerHours, _dates, _volunteerTypes, _userAddresses);
    }


    function getVolunteerSessionsByUserIdAndType(
    string memory _userId,
    string memory _volunteerType
) public view returns (
    string[] memory userIds,
    string[] memory usernames,
    uint256[] memory volunteerHours,
    string[] memory dates,
    address[] memory userAddresses
) {
    uint256 count = 0;

    // `_userId`와 `_volunteerType`에 해당하는 세션의 개수 계산
    for (uint256 i = 1; i <= sessionCounter; i++) {
        if (
            keccak256(abi.encodePacked(volunteerSessions[i].userId)) ==
            keccak256(abi.encodePacked(_userId)) &&
            keccak256(abi.encodePacked(volunteerSessions[i].volunteerType)) ==
            keccak256(abi.encodePacked(_volunteerType))
        ) {
            count++;
        }
    }

    // 각 필드를 위한 배열 생성
    string[] memory _userIds = new string[](count);
    string[] memory _usernames = new string[](count);
    uint256[] memory _volunteerHours = new uint256[](count);
    string[] memory _dates = new string[](count);
    address[] memory _userAddresses = new address[](count);

    uint256 index = 0;

    // `_userId`와 `_volunteerType`에 해당하는 세션 데이터를 배열에 저장
    for (uint256 i = 1; i <= sessionCounter; i++) {
        if (
            keccak256(abi.encodePacked(volunteerSessions[i].userId)) ==
            keccak256(abi.encodePacked(_userId)) &&
            keccak256(abi.encodePacked(volunteerSessions[i].volunteerType)) ==
            keccak256(abi.encodePacked(_volunteerType))
        ) {
            VolunteerSession memory session = volunteerSessions[i];
            _userIds[index] = session.userId;
            _usernames[index] = session.username;
            _volunteerHours[index] = session.volunteerHours;
            _dates[index] = session.date;
            _userAddresses[index] = session.userAddress;
            index++;
        }
    }

    // 배열 반환
    return (_userIds, _usernames, _volunteerHours, _dates, _userAddresses);
}

    function getCertificateByUserId(string memory userId)
        public
        view
        returns (
            string memory certificateId,
            string memory username,
            uint256 totalHours,
            string memory issueDate
        )
    {
        require(userCertificateStatus[userId], "No certificate found for this user");

        string memory certId = userToCertificate[userId];
        Certificate memory cert = certificates[certId];

        return (
            cert.certificateId,
            cert.username,
            cert.totalHours,
            cert.issueDate
        );
    }



}
