# aerobike_dev
aerobike_dev

## Cборка и публикация в dockerhub
```bash
docker build -t metaller000/aerobike_dev .
docker push metaller000/aerobike_dev
```

## Подготовка среды и запуск
###
```bash
docker pull metaller000/aerobike_dev
```
### Запуск
```bash
docker run --restart=always \
-p 9000:9000 \
-it -d -e "MONGO_URL=$(hostname -I | awk '{print $1}')" \
-v ~/Develop/Aerobike:/Aerobike \
--cpuset-cpus="0-11" \
--name=aero metaller000/aerobike_dev
```

## Работа
### Войти в докер
```bash
docker exec -it aero bash
cmake -DWITH_TESTS=1 ..
```


