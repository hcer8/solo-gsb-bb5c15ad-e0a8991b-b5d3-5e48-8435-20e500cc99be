FROM node:20-alpine

WORKDIR /app

# 依赖层：严格按 package-lock.json 安装（npm ci），保证单条命令构建结果可复现
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY server.js ./
COPY replay.js ./
COPY compare.js ./
COPY archive.js ./
COPY public ./public
# public/replay-core.js 同时被浏览器 <script> 与 Node（compare.js）require 复用，
# 已随 public 目录一并拷入；两侧执行同一份事件折叠内核

# 事件日志落盘目录（server.js 启动时自动创建；Compose 中挂载 ./data 持久化）
ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
