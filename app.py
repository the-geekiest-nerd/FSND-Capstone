from flask import Flask, request, abort, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from .database.models import db_drop_and_create_all, setup_db, Actor, Movie


def create_app(test_config=None):
    app = Flask(__name__)
    setup_db(app)
    # db_drop_and_create_all()

    CORS(app, resources={r"/*": {"origins": "*"}})

    @app.after_request
    def after_request(response):
        response.headers.add('Access-Control-Allow-Headers',
                             'Content-Type, Authorization')
        response.headers.add('Access-Control-Allow-Methods',
                             'GET, POST, PATCH, DELETE, OPTIONS')
        return response

    @app.route('/')
    def health():
        return jsonify({'health': 'Running!!'}), 200

    @app.route('/actors')
    def get_actors():
        actors_query = Actor.query.order_by(Actor.id).all()
        actors = [actor.short() for actor in actors_query]

        return jsonify({
            "success": True,
            "actors": actors
        }), 200

    @app.route('/actors/<int:actor_id>')
    def get_actor_by_id(actor_id):
        actor = Actor.query.get_or_404(actor_id)

        return jsonify({
            "success": True,
            "actor": actor.full_info()
        }), 200

    @app.route('/actors', methods=['POST'])
    def create_actor():
        try:
            request_body = request.get_json()
            if 'name' not in request_body \
                    or 'date_of_birth' not in request_body:
                raise KeyError

            if request_body['name'] == '' \
                    or request_body['date_of_birth'] == '':
                raise ValueError

            full_name = ''
            if 'full_name' in request_body:
                full_name = request_body["full_name"]

            new_actor = Actor(request_body['name'], full_name,
                              request_body['date_of_birth'])
            new_actor.insert()

            return jsonify({
                "success": True,
                "created_actor_id": new_actor.id
            }), 201

        except (TypeError, KeyError, ValueError):
            abort(422)

        except Exception:
            abort(500)

    @app.route('/actors/<int:actor_id>', methods=['PATCH'])
    def update_actor(actor_id):
        actor = Actor.query.get_or_404(actor_id)

        try:
            request_body = request.get_json()
            if not bool(request_body):
                raise TypeError

            if "name" in request_body:
                if request_body["name"] == "":
                    raise ValueError

                actor.name = request_body["name"]

            if "full_name" in request_body:
                if request_body["full_name"] == "":
                    raise ValueError

                actor.full_name = request_body["full_name"]

            if 'date_of_birth' in request_body:
                if request_body["date_of_birth"] == "":
                    raise ValueError

                actor.date_of_birth = request_body["date_of_birth"]

            actor.update()

            return jsonify({
                "success": True,
                "actor_info": actor.long()
            }), 200

        except (TypeError, ValueError, KeyError):
            abort(422)

        except Exception:
            abort(500)

    @app.route('/actors/<int:actor_id>', methods=['DELETE'])
    def delete_actor(actor_id):
        actor = Actor.query.get_or_404(actor_id)

        try:
            actor.delete()

            return jsonify({
                "success": True,
                "deleted_actor_id": actor.id
            }), 200

        except Exception:
            abort(500)

    @app.errorhandler(400)
    @app.errorhandler(404)
    @app.errorhandler(405)
    @app.errorhandler(422)
    @app.errorhandler(500)
    def error_handler(error):
        return jsonify({
            'success': False,
            'error': error.code,
            'message': error.description
        }), error.code

    return app
