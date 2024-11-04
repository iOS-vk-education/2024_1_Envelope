# 2024_1_Envelope
Проект команды Envelope по курсу "Мобильный разработчик на iOS" от VK

# Состав команды
1. Филатов Александр @alwh1te - TeamLead
2. Юлин Егор @EgorUlin - algo монстр
3. Цветков Алексей @vilegu - dev
4. Шустров Андрей @asnx9 - dev + design


# Менторы
1. Христокьян Михаил
2. Короткий Егор

# Общая информация
**Название проекта:** TwiX
**Цель проекта:** Создание микроблогингового сервиса с интерактивной лентой популярных постов, с возможностью уставноки эмодзи-тегов.
**Целевая аудитория:** Люди, желающие поделиться своим досугом и времяпрепровождением.

**Платформа:** IOS
**Язык:** Swift
**Используемые технологии:**
- **Frontend:** UIKit / SwiftUI
- **Backend:** Firebase

# Функционал
## Авторизация
- Поддержка авторизации через
    - VK ID
    - Google
    - Apple ID
    - email
- Личный профиль пользователя с возможностью редактирования личных данных

## Лента постов
- Просмотр постов по заданным фильтрам, а именно установка эмодзи-тега как в фильтр, где заданноый эмодзи характеризует настроение поста/настроение автора, в момент создания записи. Всего на посте возможна установка трех эмодзи, каждый из которых участвует в фильтрации.
- Возможность реагировать на чужие посты:
    - Лайк
    - Комментарий
    - Подписка на автора поста
- Лента поддерживат два формата постов:
    - Просматриваемый; полностью показанный пост, без сокращения информации.
    - Инактивный; пост, содержащий частичную информацию

## Создание поста
- Кнопка с символом **+** в центре нижней части экрана перенаправляет пользователя на форму с созданием поста, где он имеет возможность:
    - Выбрать подходящий эмодзи-тег, определяющий настроение поста
    - Написать контент для записи
    - Установить изображение

## Профиль
- Собственная страница, характеризующая пользователя, на которой имеется
    - Аватар (изображение)
    - Имя
    - Статус
    - Характеристика
    - Лента, состоящая целиком из постов данного пользователя
- Возможность отслеживать действия - подписка


# Распределение обязанностей
- Экран авторизации - Юлин Егор
- Главный экран с лентой постов - Шустров Андрей
- Форма создания постов + экран настроек - Филатов Александр
- Экран профиля - Цветков Алексей

# Ресурсы команды
- Таск-трекер 
    - https://tracker.yandex.ru/agile/boards
- Дизайн
    - https://www.figma.com/files/team/1428766100175325145/all-projects?fuid=1420735539743927044
