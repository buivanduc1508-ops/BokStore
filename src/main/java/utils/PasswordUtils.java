package utils;

import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtils {
  private PasswordUtils() {}

  public static String hash(String password) {
    try {
      byte[] salt = new byte[16];
      new SecureRandom().nextBytes(salt);
      byte[] key =
          SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
              .generateSecret(new PBEKeySpec(password.toCharArray(), salt, 65536, 256))
              .getEncoded();
      return "pbkdf2$65536$"
          + Base64.getEncoder().encodeToString(salt)
          + "$"
          + Base64.getEncoder().encodeToString(key);
    } catch (Exception e) {
      throw new IllegalStateException(e);
    }
  }

  public static boolean verify(String password, String stored) {
    try {
      if (stored == null) return false;
      if (!stored.startsWith("pbkdf2$")) return password.equals(stored);
      String[] p = stored.split("\\$");
      byte[] salt = Base64.getDecoder().decode(p[2]), expected = Base64.getDecoder().decode(p[3]);
      byte[] actual =
          SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
              .generateSecret(
                  new PBEKeySpec(
                      password.toCharArray(), salt, Integer.parseInt(p[1]), expected.length * 8))
              .getEncoded();
      int diff = expected.length ^ actual.length;
      for (int i = 0; i < Math.min(expected.length, actual.length); i++)
        diff |= expected[i] ^ actual[i];
      return diff == 0;
    } catch (Exception e) {
      return false;
    }
  }
}
