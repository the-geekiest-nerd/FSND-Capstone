from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand

from app import flask_app
from database.models import db

migrate = Migrate(flask_app, db)
manager = Manager(flask_app)

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
