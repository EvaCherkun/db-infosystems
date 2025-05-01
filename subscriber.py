import redis
import time

redis_host = 'localhost'
redis_port = 6379
redis_db = 0
channel_name = 'news'

try:
    r = redis.Redis(host=redis_host, port=redis_port, db=redis_db, decode_responses=True)
    pubsub = r.pubsub()
    pubsub.subscribe(channel_name)

    print(f"Підписано на канал '{channel_name}'. Очікування повідомлень...")

    for message in pubsub.listen():
        if message['type'] == 'message':
            print(f"Отримано повідомлення: {message['data']}")
        elif message['type'] == 'subscribe':
            print(f"Успішно підписано на канал '{message['channel']}'")

except redis.exceptions.ConnectionError as e:
    print(f"Не вдалося підключитися до Redis: {e}")
except KeyboardInterrupt:
    print("Завершення скрипту.")
finally:
    if 'pubsub' in locals() and pubsub.subscribed:
        pubsub.unsubscribe(channel_name)
        print(f"Відписано від каналу '{channel_name}'.")