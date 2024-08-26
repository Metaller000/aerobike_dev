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
docker run --restart=always --network host -v $(pwd):/Aerobike  metaller000/aerobike_dev
# пройти по ссылке http://localhost:666/
```

## Работа
### Войти в докер
```bash
docker exec -it aero bash
cmake -DWITH_TESTS=1 ..
```


