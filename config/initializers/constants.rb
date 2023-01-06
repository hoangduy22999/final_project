# frozen_string_literal: true

VALID_EMAIL_REGEX = /\A\S+@\S+\.\S+/i
PASSWORD_FORMAT = /\A(?=.*[a-z])(?=.*[0-9])(?=.*\W).{8,16}\z/i
EXPIRED_TIME = 15
