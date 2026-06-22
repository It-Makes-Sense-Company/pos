# Wiki Schema — Personal Brand Operating System

> Шаблон доменной схемы для памяти POS-агента. Копируется в каждую вики-субъекта
> (`$WIKI_PATH/SCHEMA.md`) и заполняется под человека. Движок — встроенный skill
> `llm-wiki` (паттерн Карпатого); эта схема задаёт ПРАВИЛА, которым он следует.

## Domain
Память личного бренда ОДНОГО человека («субъект»). Не generic knowledge base.
Питает IMS Personal Operating System: кто субъект, как коммуницирует, о чём ему
говорить, что уже сказано — чтобы агент давал обоснованные советы, подкидывал темы
(Sense Engine), фильтровал шум и собирал коммуникационную стратегию.

**Субъект:** {{SUBJECT}}

## Core principle (Karpathy LLM Wiki + IMS «мостик»)
- `raw/` — immutable истина (что субъект и интернет реально сказали). Читать, цитировать, НЕ править.
- wiki-страницы — синтез, который ведёт агент.
- этот `SCHEMA.md` — правила.
- **IMS-добавка — «мостик»:** отслеживаем РАЗРЫВ между тем, как субъект видит себя
  (CV, самоописание, голосовые), и как он представлен в паблике (LinkedIn, посты,
  интернет). Разрыв = «белые пятна» = продающий инсайт и бэклог работы. Это
  first-class вывод вики (план 03).

## Conventions
- Имена файлов: lowercase, дефисы, latin-ascii (`tone-of-voice.md`, `projects/pocket-listings.md`). Контент — на языке субъекта (RU ок).
- Каждая страница: YAML-frontmatter (ниже) + ≥2 `[[wikilinks]]`.
- При обновлении — бампить `updated`, пересматривать `as_of`/`weight`.
- Новая страница → в `index.md`. Новый тег → сперва в таксономию.

## Frontmatter
```yaml
---
title: ...
type: core | summary | positioning | audience | pillar | voice | theme | project | person | org | achievement | strategy | posts-log | query
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [из таксономии ниже]
sources: [raw/...]
# --- IMS recency layer («срок давности»: старое = менее релевантно) ---
as_of: YYYY-MM-DD          # дата, на которую факт верен (дата источника/события)
horizon: current | recent | historical   # сегодняшний фокус / недавнее / архив карьеры
weight: high | medium | low               # релевантность для СЕГОДНЯШНЕЙ коммуникации
# --- опционально ---
confidence: high | medium | low
perspective: self | public                # из самооценки или из публичного поля
gap: true                                 # белое пятно (заявлено, но нет в паблике, или наоборот)
contested: true                           # неразрешённое противоречие
contradictions: [other-page-slug]
---
```
**Recency-правила:**
- Роль 7-летней давности → `horizon: historical`, `weight: low`. Не тащить в сегодняшние темы без явной нужды.
- Новые источники старшинствуют над старыми (противоречие — фиксировать оба с датами).
- Lint флажит `weight: high` страницы, чей `as_of` старше 18 мес — на пересмотр.

## Page structure — «хребет» бренда
Спайн-страницы (всегда есть, агент их поддерживает):

| Файл | Что | Грузить |
|---|---|---|
| `core.md` | Сжатое ядро ~1 экран: кто сейчас, голос в 3 строки, главные темы, табу, как работать с субъектом | ВСЕГДА первым (якорь ориентации) |
| `executive-summary.md` | Кто сейчас / сильнейшие скиллы / прогноз «кем будешь через год» / defining-моменты / **разрыв самооценка↔паблик** | стратегия, питч, онбординг |
| `positioning.md` | Позиционирование, отличия, вектор (откуда → куда) | стратегия |
| `audiences.md` | Для кого, что им важно | стратегия, тема |
| `tone-of-voice.md` | Голос, структура поста, фирменные концепции, do/don't, анти-примеры | любой текст |
| `themes-map.md` | Территории тем + банк идей из источников + **белые пятна** | идея/тема/контент-план |
| `communication-strategy.md` | Зачем, цели, каналы, воронка, контент-план (синтез спайна) | стратегия |
| `posts-log.md` | Реестр сказанного/опубликованного (тема/статус/дата) | дедуп, контент-план |

Переменные страницы: `pillars/<pillar>.md` · `projects/<slug>.md` · `people/<slug>.md` ·
`orgs/<slug>.md` · `concepts/<slug>.md` (нарративы) · `queries/<slug>.md`.

`raw/` раскладка: `raw/cv/` · `raw/linkedin/` · `raw/posts/` · `raw/transcripts/` ·
`raw/research/` (досье Perplexity/exa) · `raw/assets/`.

## Tag taxonomy (добавлять до использования)
- Идентичность: `identity` `role` `skill` `defining-moment` `forecast`
- Позиционирование: `positioning` `audience` `differentiation` `vector`
- Контент: `pillar` `theme` `idea` `white-spot` `taboo` `hook`
- Голос: `voice` `structure` `signature-concept` `anti-example`
- Сущности: `project` `person` `org` `achievement` `media`
- Стратегия: `strategy` `channel` `funnel` `goal` `metric`
- Мета: `gap` `contested` `historical` `current`

## Page thresholds
- Создавать страницу, когда сущность/тема встречается в 2+ источниках ИЛИ центральна для одного.
- Не плодить страницы на проходные упоминания.
- Спайн-страницы существуют всегда, даже тонкие (помечать `confidence: low` / TODO).

## Workflows (поверх generic llm-wiki)
### Ingest — с «мостиком»
Базовый ingest llm-wiki (capture raw → обсудить → проверить существующее →
писать/обновлять → index/log → отчитаться), ПЛЮС:
1. Размечать каждому факту `horizon`/`weight`/`as_of` (recency).
2. Классифицировать источник: `perspective: self` (CV, самоописание, голосовые) vs
   `perspective: public` (LinkedIn, посты, интернет-ресёрч).
3. **Gap-проход:** где субъект заявляет трек (self), которого нет в паблике → `gap: true`
   на соответствующей теме/скилле + в «белые пятна» `themes-map.md`. И наоборот.
4. **Порядок важен (план 03):** в онбординге сперва зафиксировать самооценку субъекта,
   ПОТОМ сверять с публичным/LLM-взглядом; разрыв = инсайт. Не вываливать публичное summary в лоб.

### Query — обоснованно, готово под Sense Engine
Стандартный query llm-wiki. Для подсказки тем (Sense Engine) — из `themes-map.md` +
белые пятна + `pillars/`, фильтр по `weight: high`/`current`. Не предлагать офф-бренд
или устаревшие темы. Финальный текст НЕ пишем за субъекта (граница плана 02).

### Lint — здоровье бренда
Стандартный lint llm-wiki ПЛЮС:
- **Stale-but-prominent:** `weight: high` со `as_of` старше 18 мес → на пересмотр.
- **Открытые белые пятна:** список всех `gap: true`.
- **Провисшие пиллары:** `pillars/` без свежих постов в `posts-log.md`.
- **Полнота спайна:** спайн-страницы, оставшиеся `confidence: low`/TODO.

## Out of scope
Не генератор постов. Вики даёт субъекту идеи и структуру; финальный текст он пишет сам
(границы плана 02). Не подключаемся ко всем инструментам клиента.
