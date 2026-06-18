import express from 'express';
import cors from 'cors';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 检查 Ollama 是否可用
app.get('/api/ollama/health', async (req, res) => {
  try {
    const response = await fetch('http://localhost:11434/api/tags');
    if (response.ok) {
      const data = await response.json();
      res.json({ status: 'ok', models: data.models || [] });
    } else {
      res.status(503).json({ status: 'error', message: 'Ollama 未运行' });
    }
  } catch (error) {
    res.status(503).json({ status: 'error', message: '无法连接 Ollama' });
  }
});

// 获取模型列表
app.get('/api/ollama/models', async (req, res) => {
  try {
    const response = await fetch('http://localhost:11434/api/tags');
    const data = await response.json();
    res.json(data.models || []);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch models' });
  }
});

// 流式对话接口
app.post('/api/chat', async (req, res) => {
  const { messages, model = 'qwen2.5:3b' } = req.body;

  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ error: 'Invalid messages' });
  }

  try {
    // 设置 SSE
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders();

    // 调用 Ollama
    const ollamaResponse = await fetch('http://localhost:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: model,
        messages: messages,
        stream: true
      })
    });

    if (!ollamaResponse.ok) {
      throw new Error('Ollama 请求失败');
    }

    // 流式转发
    const reader = ollamaResponse.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      const chunk = decoder.decode(value);
      res.write(chunk);
    }

    res.write('data: [DONE]\n\n');
    res.end();

  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ error: error.message });
  }
});

// 非流式对话接口（备选）
app.post('/api/chat-complete', async (req, res) => {
  const { messages, model = 'qwen2.5:3b' } = req.body;

  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ error: 'Invalid messages' });
  }

  try {
    const response = await fetch('http://localhost:11434/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: model,
        messages: messages,
        stream: false
      })
    });

    const data = await response.json();
    res.json(data);

  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log('');
  console.log('╔════════════════════════════════════════════╗');
  console.log('║      本地 AI 小说助手 - 服务端已启动      ║');
  console.log('╠════════════════════════════════════════════╣');
  console.log(`║  本地地址: http://localhost:${PORT}           ║`);
  console.log('║  请保持此窗口开启                          ║');
  console.log('╚════════════════════════════════════════════╝');
  console.log('');
  console.log('提示: 同时运行 "6-启动-内网穿透.bat"');
  console.log('     才能让手机从外部访问');
  console.log('');
});
