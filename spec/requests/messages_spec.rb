# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Message Creation" do
  describe "POST /m" do
    context "with valid expiration_duration" do
      it "creates a message with correct expiration" do
        freeze_time do
          post "/m", params: {
            message: {
              body: "Test message for integration",
              expiration_duration: "one_hour"
            }
          }

          expect(response).to have_http_status(:found)
        end
      end

      it "sets the correct message body" do
        freeze_time do
          post "/m", params: {
            message: {
              body: "Test message for integration",
              expiration_duration: "one_hour"
            }
          }

          message = Message.last
          expect(message.body).to eq("Test message for integration")
        end
      end

      it "sets the correct expiration time" do
        freeze_time do
          post "/m", params: {
            message: {
              body: "Test message for integration",
              expiration_duration: "one_hour"
            }
          }

          message = Message.last
          expect(message.expires_at).to be_within(1.second).of(1.hour.from_now)
        end
      end
    end

    context "with no expiration" do
      it "creates a message without expiration" do
        post "/m", params: {
          message: {
            body: "Permanent message",
            expiration_duration: ""
          }
        }

        expect(response).to have_http_status(:found)
      end

      it "sets the correct message body" do
        post "/m", params: {
          message: {
            body: "Permanent message",
            expiration_duration: ""
          }
        }

        message = Message.last
        expect(message.body).to eq("Permanent message")
      end

      it "sets expires_at to nil" do
        post "/m", params: {
          message: {
            body: "Permanent message",
            expiration_duration: ""
          }
        }

        message = Message.last
        expect(message.expires_at).to be_nil
      end
    end

    context "with invalid data" do
      it "renders the form again with errors" do
        post "/m", params: {
          message: {
            body: "",
            expiration_duration: "one_hour"
          }
        }

        expect(response).to have_http_status(:success)
      end

      it "does not create a message with invalid data" do
        post "/m", params: {
          message: {
            body: "",
            expiration_duration: "one_hour"
          }
        }

        expect(Message.count).to eq(0)
      end
    end
  end
end
