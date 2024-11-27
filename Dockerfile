# Use Node.js 18 or higher
FROM node:18

# 작업 디렉토리 설정
WORKDIR /app

# 프로젝트 의존성 설치
COPY package*.json ./

# Install dependencies including Truffle
RUN npm install

# 프로젝트 파일 복사
COPY . .

# 포트 노출 (Ganache의 기본 포트인 7545 사용)
EXPOSE 7545

# 스마트 계약 배포 (npx 사용하여 로컬 설치된 truffle 사용)
CMD ["npx", "truffle", "migrate", "--network", "development"]
