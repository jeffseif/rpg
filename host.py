from flask import Flask
from flask import render_template


app = Flask(__name__, template_folder='')


def build():
    with app.app_context():
        print(render_template('template.html'))


@app.route('/')
def root():
    return render_template('index.html')


if __name__ == '__main__':
    build()
