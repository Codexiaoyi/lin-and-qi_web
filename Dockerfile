FROM node:14-alpine as build-stage

# npm镜像，解决报错而引入
RUN npm config set registry https://registry.npm.taobao.org
RUN npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass

# install simple http server for serving static content
# 全局http-server用于本地运行
#RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
# 生产打包，对应脚本"build": "node build/build.js"
RUN npm run build:prod
#本地，对应脚本"dev": "webpack-dev-server --inline --progress --config build/webpack.dev.conf.js"
#RUN npm run dev

# production stage
#代理nginx，nginx直接访问
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

#本地对应端口
#EXPOSE 8088
#CMD [ "http-server", "dist" ]