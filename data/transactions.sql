CREATE TABLE transactions
(
  guid character varying(36) NOT NULL,
  date bigint,
  value real,
  kind character varying(256),
  deleted boolean DEFAULT false,
  user_id serial NOT NULL,
  CONSTRAINT transactions_guid_primary_key PRIMARY KEY (guid),
  CONSTRAINT "transactions-to-user_foreign-key" FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Default data
INSERT INTO transactions VALUES ('3F2504E0-4F89-41D3-9A0C-0305E82C3301', 1439291119937, 16004, 'incoming payment', false, 1);
INSERT INTO transactions VALUES ('3F2504E0-4F89-41D3-9A0B-0305E82C3301', 1439291119937, -500, 'transaction fee', false, 1);
INSERT INTO transactions VALUES ('3F2504E0-4F89-41D3-9A0D-0305E82C3301', 1439291119937, 1500, 'incoming payment', false, 1);
INSERT INTO transactions VALUES ('3F2504E0-4F89-41D3-9A0A-0305E82C3301', 1439291119937, 12300, 'incoming payment', false, 1);