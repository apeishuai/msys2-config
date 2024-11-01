// 引入 express 模块
const express = require('express');

// 创建一个 express 应用
const app = express();

// 定义一个路由来响应 GET 请求到根 URL
app.get('/', (req, res) => {
  res.send('Hello, World!');
});

// 定义服务器监听的端口
const PORT = 3000;

// 启动服务器并监听指定的端口
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
