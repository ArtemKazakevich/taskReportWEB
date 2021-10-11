//счетчики аттрибутов и классов
let iAttribute = 1;
let iClass = 1;

//находим атрибуты и классы для изменения
const buttonsAttribute = document.querySelectorAll('[data-bs-target]');
const buttonsClass = document.querySelectorAll('.collapse');

//перебираем атрибуты
buttonsAttribute.forEach(element => {
    element.setAttribute('data-bs-target', '#collapseExample' + iAttribute++);
});

// перебираем классы
buttonsClass.forEach(element => {
    element.setAttribute('id', 'collapseExample' + iClass++);
});

// спиннер
document.body.onload = function() {

    setTimeout(function() {
        var preloader = document.getElementById('page-preloader'); // находим наш id - page-preloader
        if( !preloader.classList.contains('done') )
        {
            preloader.classList.add('done'); // добавляем класс done, если его нет
        }
    }, 1000); // preloader исчезнет через 1с
}