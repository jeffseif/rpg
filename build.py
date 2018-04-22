from flask import Flask
from flask import render_template


app = Flask(__name__, template_folder='')


def main():
    with app.app_context():
        print(render_template('template.html'))


if __name__ == '__main__':
    main()
