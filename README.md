# Измерение пройденного расстояния по данным с гироскопа и акселерометра с помощью фильтра Калмана / Measuring the distance traveled from gyroscope and accelerometer data using Kalman filter

*Разработчик/Developer*
1. [Андрей Недов](github.com/Andrey-Nedov-is-a-human)

<img src="/imgs/img1.jpg" width="700"/>

Данный проект является финальным по курсу Estimation theory Ульсанского Университета, пройденного во время стажировки в Южной Корее. 
На протяежении семестрового курса поэтапно изучался фильтр Калмана. Для практических работ использовались данные о шагах человека, 
записанные с акселерометра и гироскопа прикреплённых к ноге человека.

## Задачи финального проекта

Основной задачей курса является разработка алгоритма точного подсчёта пройденногого расстояния по данным с акселерометра и гироскопа, прикрепленных к подошве ботинка человека.

Задачами финального проекта является доработка алгоритма написанного в течение курса, и реализованного при помощи MathLab:

_Пока нога ототорвана от земли датчики накапливают ошибку. Мы полагаем что в течение каждого шага есть период когда нога находится на земле и её скорость относительно земли равна нулю. Таким образом мы можем сбрасывать накопленную ошибку во время каждого шага. Для реализации такого механизма нам нужно добавить к уже имеющимся в мартрице измерений проекта (H) скоростям по трём осям z координату._

1. Добавить z координату в набор измеряемых параметров фильтра Калмана
2. Релаизовать алгортим детектирования состояния когда нога находится на земле
3. Полученным алгоритмом измерить пройденное расстояние на трёх разных наборах данных (longwalking1.mat, longwalking2.mat, running.mat)

## Ход работы

_z_ - вектор измеряемых параметров
_H_ - матрица измерений 
_x_ - вектор истинного состояния параметров
_v_ - гауссовский шум

<img src="/imgs/img2.jpg" width="700"/>

Проинтегрировав данные с акселерометра мы получаем следующие результаты

<img src="/imgs/img3.jpg" width="700"/>

Данные с акселерометра и гироскопа

<img src="/imgs/img4.jpg" width="700"/>

Определяем области нулевой скорости на акселерометре

<img src="/imgs/img5.jpg" width="700"/>

Определяем области нулевой скорости на гироскопе

<img src="/imgs/img6.jpg" width="700"/>

Делаем пересечение полученных областей

<img src="/imgs/img7.jpg" width="700"/>
<img src="/imgs/img8.jpg" width="700"/>

Определяем центры областей для рассчёта векторов передвижения ноги и складываем полученные расстояния между шагами.

<img src="/imgs/img9.jpg" width="700"/>

Получили хорошие результаты по трём наборам данных. Судя по графикам данных с датчиков ошибка с набора данных с бегом больше остальных, так как определение нулевой скорости на нём работает немного хуже. Тем не менее, результаты очень близки к реальным. Финальный проект был сдан на оценку отлично и стал последней работой на замечательном курсе.

