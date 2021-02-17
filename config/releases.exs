# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

parser_sqs_url =
  System.get_env("PARSER_SQS_QUEUE_URL") ||
    raise """
    environment variable PARSER_SQS_QUEUE_URL is missing.
    """

config :xq_archive,
  parser_sqs_url: parser_sqs_url

config :xq_archive, XQ.Archive.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :xq_archive, XQ.ArchiveWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "6391"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true
