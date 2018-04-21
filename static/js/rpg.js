var CONVERTER = new showdown.Converter();
var MARKDOWNS = [
    'title',
    'statistics',
    'characteristics',
    'skills',
    'equipment',
];

function markdownToHTML(id) {
    var markdown = document.getElementById(id).innerHTML;
    return CONVERTER.makeHtml(markdown);
}

function insertHTML() {
    var display = document.getElementById('display');

    var html = '';
    for (let markdown of MARKDOWNS) {
        html += markdownToHTML(markdown);
    }

    display.innerHTML = html;
}

window.onload = insertHTML;
