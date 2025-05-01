import redis
import time

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

r.hset("profile", mapping={"name": "Eva", "city": "Kyiv"})
print("Name:", r.hget("profile", "name"))


r.lpush("tasks", "Finish Redis homework")
tasks = r.lrange("tasks", 0, -1)
print("Tasks:", tasks)


r.set("temp:data", "Hello!", ex=10)
ttl = r.ttl("temp:data")
print("TTL:", ttl)


print("Чекаємо 11 секунд...")
time.sleep(11)


value = r.get("temp:data")
if value is None:
    print(" Ключ 'temp:data' видалено після TTL.")
else:
    print("Ключ все ще існує:", value)


count = r.incr("launch_counter")
print(f"This script has been run {count} times.")


r.publish("updates", "Script was just executed!")
