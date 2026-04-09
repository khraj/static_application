FROM nginx:alpine

#copy simple.html to nginx server
COPY simple.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

#Start Nginx
CMD ["nginx", "-g", "deamon of;"]
