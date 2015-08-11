CREATE TABLE "users"
(
  id serial NOT NULL,
  user_name character varying(32) NOT NULL,
  password character varying(32),
  CONSTRAINT user_pkey PRIMARY KEY (id)
);

INSERT INTO users (user_name, password) VALUES ('anton_dekterov', '900150983cd24fb0d6963f7d28e17f72');