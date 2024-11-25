require('dotenv').config();
const express = require('express');
const app = express();
const cors = require('cors');
const path = require('path');
const port = process.env.PORT || 3000;

const router = require('./src/router');
const bodyParser = require('body-parser');
app.use(cors());
app.use(bodyParser.json());
app.options('*', cors());

app.use('/', router);
app.use(cors({
    origin: '*',  // 모든 도메인 허용 (보안 위험이 있으므로 개발 중에만 사용)
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
}));

app.listen(port, () => {
    console.log('웹서버 구동중... ', port);
});