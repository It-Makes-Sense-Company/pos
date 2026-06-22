# Парсинг источников по ссылке (Telegram, LinkedIn)

Задача: пользователь даёт ссылки (канал, LinkedIn) — нам нужно вытащить контент в `raw/`
без ручного копирования. Итоги ресёрча (июнь 2026).

## Telegram-канал — ✅ решено, без API/логина
Публичный веб-превью **`https://t.me/s/<username>`** отдаёт посты как HTML — открыто для
любого канала с включённым preview. Ноль ключей, ноль аккаунта, ноль риска.
- Проверено в проде: вытащили `t.me/s/niketasfm` (бот сайта/агент) — 19 постов + bio.
- Для агента: `web_extract`/fetch по `t.me/s/<username>` → в `raw/posts/`.
- Глубокий архив (пагинация до первого поста): скрипты на том же `t.me/s/` —
  [Steelio/Telegram-Post-Scraper](https://github.com/Steelio/Telegram-Post-Scraper),
  [ergoncugler/web-scraping-telegram](https://github.com/ergoncugler/web-scraping-telegram),
  или Apify-акторы (пагинация + мультиканал, без логина).
- Закрытые каналы / полная история с медиа — только Telethon (userbot, нужен телефон/сессия); откладываем.

## LinkedIn — ⚠️ нужен платный скрейпер по URL
Прямой фетч невозможен (login-wall, антибот). **Proxycurl закрыт в 2025** после иска LinkedIn —
не использовать. Актуальные варианты 2026 (pay-per-result по URL профиля):
- **Apify «LinkedIn Profile Scraper»** — ~$0.005–0.01 за профиль, актор по URL. Рекомендуемый старт (дёшево, по запросу).
- **Bright Data** LinkedIn Profile Scraper — детальные публичные данные (имя, summary, опыт, образование).
- **Scrapingdog** LinkedIn Profile API.
- Open-source (Swordfish и т.п.) — нестабильны, ломаются на изменениях LinkedIn. Не для прода.
- Альтернатива без скрейпера: попросить пользователя **экспорт данных LinkedIn** (Settings → Get a copy of your data) или вставку текста About+Experience.

**Решение для MVP:** канал — через `t.me/s/`; CV — пользователь даёт (Outline/файл); LinkedIn —
либо вставка/экспорт от пользователя, либо подключить Apify-актор (нужен API-ключ Apify) как
платный шаг обработки. Пока LinkedIn не критичен: CV покрывает ту же фактуру.

## Связь
Это раздел 2 плана 03 (состав пакета данных) и open-вопрос #1 (сломанный экспорт Telegram —
обходим через `t.me/s/`).
