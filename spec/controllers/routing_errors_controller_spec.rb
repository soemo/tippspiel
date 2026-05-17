require 'rails_helper'

describe RoutingErrorsController do

  describe 'GET #show' do

    context 'with bot/scanner paths' do

      context 'PHP file probes' do
        it 'returns 404 silently for .php files' do
          get :show, params: { unknown_route: 'admin.php' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for wp-login.php' do
          get :show, params: { unknown_route: 'wp-login.php' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for mixed-case PHP extension like .PhP7' do
          get :show, params: { unknown_route: 'randkeyword.PhP7' }
          expect(response).to have_http_status(:not_found)
        end

        it 'does not raise an exception for PHP probes' do
          expect { get :show, params: { unknown_route: 'xmlrpc.php' } }.not_to raise_error
        end
      end

      context 'WordPress path probes' do
        it 'returns 404 silently for wp- prefixed paths' do
          get :show, params: { unknown_route: 'wp-content/uploads/index.php' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for wp-admin' do
          get :show, params: { unknown_route: 'wp-admin/user.php' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for wp-includes' do
          get :show, params: { unknown_route: 'wp-includes/PHPMailer' }
          expect(response).to have_http_status(:not_found)
        end
      end

      context '.env file harvesting' do
        it 'returns 404 silently for .env' do
          get :show, params: { unknown_route: '.env' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for .env.local' do
          get :show, params: { unknown_route: '.env.local' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for .env.production' do
          get :show, params: { unknown_route: '.env.production' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for .env nested in a subdirectory' do
          get :show, params: { unknown_route: 'laravel/.env' }
          expect(response).to have_http_status(:not_found)
        end

        it 'returns 404 silently for .env nested deeply' do
          get :show, params: { unknown_route: 'api/v1/.env' }
          expect(response).to have_http_status(:not_found)
        end
      end

      context '.git probes' do
        it 'returns 404 silently for .git/config' do
          get :show, params: { unknown_route: '.git/config' }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'cgi-bin probes' do
        it 'returns 404 silently for cgi-bin' do
          get :show, params: { unknown_route: 'cgi-bin' }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'with legitimate unknown routes' do
      it 'raises ActionController::RoutingError for a genuinely unknown path' do
        expect { get :show, params: { unknown_route: 'some/unknown/app/path' } }
          .to raise_error(ActionController::RoutingError, /Unknown route some\/unknown\/app\/path/)
      end

      it 'raises ActionController::RoutingError for a typo in a real route' do
        expect { get :show, params: { unknown_route: 'halll-of-fame' } }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end
end
