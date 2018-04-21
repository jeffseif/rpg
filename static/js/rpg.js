var CONVERTER = new showdown.Converter({tables: true});

function markdownToHTML(markdown) {
    return (
            '<div class="html">'
        +   CONVERTER.makeHtml(markdown.innerHTML)
        +   '</div>'
    );
}

function insertHTML() {
    var display = document.getElementById('display');

    var html = '';
    var markdowns = document.getElementsByClassName('markdown');
    for (let markdown of markdowns) {
        html += markdownToHTML(markdown);
    }

    display.innerHTML = html;
}

window.onload = insertHTML;
