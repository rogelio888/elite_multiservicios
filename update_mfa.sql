UPDATE mfa_challenge SET "codeHash" = '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', attempts = 0 WHERE id = (SELECT id FROM mfa_challenge ORDER BY id DESC LIMIT 1);
