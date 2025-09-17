# [not-just-a-developer.com](http://not-just-a-developer.com)

This is just a blog from not just a developer.


## References
- static site generator [zola][1]
- theme [radion][2]
- font [JetBrains Mono][3], but downloaded via [google fonts][4]

[1]: https://github.com/getzola/zola
[2]: https://github.com/micahkepe/radion
[3]: https://github.com/JetBrains/JetBrainsMono
[4]: https://fonts.google.com/specimen/JetBrains+Mono


## Ghostfolio

Ghostfolio is also installed. If I ever (and I'll probably have this again) lose my key, here's how to generate a new one:

log into postgresql pod:
```bash
kubectl exec -it postgres-5cb99454c-abcde -- bash
psql -U user -d ghostfolio-db
```

```bash
USER_ID="<uuid from db table 'User'>"
RANDOM_SALT=$(openssl rand -hex 5)
# this is the new accesstoken to use in the web ui
echo -n "$USER_ID" | openssl dgst -sha512 -hmac "$RANDOM_SALT"

ACCESS_TOKEN_SALT="defined as env variable when in ghostfolio manifest"
# this is the one to save in db.User.accessToken
echo -n "$ACCESS_TOKEN" | openssl dgst -sha512 -hmac "$ACCESS_TOKEN_SALT"
```

```sql
UPDATE "User"
SET "accessToken" = '<128 hex chars>', "updatedAt" = now()
WHERE id = '<my-user-id>';
```
