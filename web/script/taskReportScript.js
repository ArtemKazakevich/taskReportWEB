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