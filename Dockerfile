# Node.js 기반 이미지
FROM node:16

# Truffle 설치
RUN npm install -g truffle

# 작업 디렉토리 설정
WORKDIR /app

# 프로젝트 의존성 설치
COPY package*.json ./
RUN npm install

# 프로젝트 파일 복사
COPY . .

# 포트 노출 (Ganache의 기본 포트인 7545 사용)
EXPOSE 7545

# 스마트 계약 배포
CMD ["truffle", "migrate", "--network", "development"]
