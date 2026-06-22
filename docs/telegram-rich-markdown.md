# Telegram: расширенный рендер Markdown (Rich Messages)

**Проблема.** Сообщения агента приходили в Telegram без форматирования — сырой
`**текст**`, заголовки и списки не рендерились. Причина: Hermes по умолчанию гонит
ответы через легаси-путь **MarkdownV2** (хрупкое экранирование, при сбое — фолбэк в
plain text), а нативные **Bot API 10.1 Rich Messages** (`sendRichMessage` с полем
`markdown`) включены опционально и только для таблиц/чек-листов/`<details>`/формул.

**Решение** (в духе Pocket Listings — «Rich Messages для всего структурного вывода»):
1. **Включить Rich Messages** — в `~/.hermes/config.yaml`:
   ```yaml
   platforms:
     telegram:
       extra:
         rich_messages: true
   ```
2. **Расширить триггер** `_needs_rich_rendering` в адаптере, чтобы через Rich шли и
   обычные конструкции — заголовки, жирный, списки, цитаты, кодоблоки. Патч:
   `patches/telegram-rich-markdown.patch` (правит
   `plugins/platforms/telegram/adapter.py`).

После Rich использует **сырой Markdown агента** (поле `markdown`), без MarkdownV2-эскейпинга
→ форматирование рендерится как есть. Короткие неформатированные ответы («ok») остаются на
лёгком пути. Кириллица не попадает под CJK-исключение Hermes — нам подходит. Реализация
`sendRichMessage` идёт через raw API (`do_api_request`), так что работает на
`python-telegram-bot 22.6`. При сбое rich-отправки есть штатный фолбэк на легаси-путь.

## Как переналожить после обновления Hermes
`vendor/` (клон Hermes) в git не коммитится и перезатирается при переустановке.
Патч идемпотентно накладывается заново:
```bash
cd /projects/pos/vendor
git apply --check ../patches/telegram-rich-markdown.patch && \
git apply ../patches/telegram-rich-markdown.patch
sudo systemctl restart hermes-gateway
```
Либо `bash /projects/pos/patches/apply.sh`.

## TODO
- Завести issue/PR в upstream Hermes на конфиг-флаг «always rich» — чтобы убрать патч.
