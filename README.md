# TereZZa
Оскільки викладач почав оформлювати гойду за здачу після дедлайну, було свторено програмне рішення для вирішення цієї проблеми.  
Підтримуванні платформи: Micros\*ft W\*ndows.
# Встановлення
Завантажте (або скомпілюйте) бінарний файл, встановіть Google Drive для комп'ютера та синхронізуйту потрібну теку.  
# Компіляція
```bash
zig build -Doptimize=ReleaseFast
```
# Час створення
Не знаю чи хтось буде звертати увагу на час створення файлу на диску, але раптом. Безпосередньо його модифікувати неможливо, але можна створювати файли з поточним часом та потім їх модифікувати.  
Для автоматизації створення файлів можна вкиористовувати наступні аргументи:
```bash
tereZZa init C:\path\to\assignments КП-ХХ дзшки-мкр
```
# Час модифікації
За допомогою цих аргументів можна змінити час модифікації всіх файлів у теці:
```bash
tereZZa C:\path\to\assignments yyyy-mm-ddThh:mm:ssZ
```
Потрібно враховувати часовий пояс. Формат дати в ISO 8601. Якщо Вам здається цей формат заскладним для використання, то, можливо, Вам і дійсно пора відрахуватися.