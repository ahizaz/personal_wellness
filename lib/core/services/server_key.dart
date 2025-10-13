import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> serverToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "personalwellness-192da",
          "private_key_id": "9e228b2e803def129833027e0a615bf42fc5f740",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCLMNYODMCJjLDJ\nO6ENEmPuJwO5zfeAc36/W7Xw5bp+hU4Vk14XXB9YThPGAF8syTLwPV2oppc/Pg5i\nfTH7/qdyRUUYLvUvHgTBAsQdnDYRnXEWUmAdwv1RBmNIhfEn4jKwBKlIUvqHiRJH\n5JSJ9UNzD351yi8SNhnDrtG0oI2Os8buCeXk9GzYlcSkdpJIJYsOTmeHSkT6yNfT\n0HHHOvBGJb7QNJoV1H9Xx6AvlK64yCkfNHTe+rqJagGmqqkHJv4hC8lCmyhA82aZ\nE3nb+en6KYJr5aLz9HFXjFQB53/TvT/5gXos+W7ZrgA2rxLi5ZMoTWXVju3rIBLj\nYPspcsCNAgMBAAECggEAEdHfGw4KOadCcYY/Iyj0lDvNyqQ83ebAwQehGRtAL2HU\n/QbQkqsKSZ2NWIRvADvYrVBzRNvhxzNPAiWcbZz3m7Xp7PkDY38zWpvbtx1rAAGp\nGxN8F14BsmA1URvyI4oJCpHo3kfep9V7pVVKqF2Mahb/Y13O0u+23V+XR3RlSxyM\nBKNlu5BcWRe5HnWx8+8ASC9RVIAo9NvDJIhUr8mtntmRtqcorDbl21E4OO3xgw9d\nTwnBsC4NqGWvBU6zqD42Xs+CyaUaPkF+bh1f+nMNrVSpmYdk80kk5NmFOUE8W7/+\n7rMHQI38E5L3Z7BYYcTgqZ6zj+vx98j2jzmtMSIFPQKBgQDBtc7U/YgElomKUWyC\nAxJ0wY0/3hRQx5i23LacuHE4kQbruvbvyC92wpl+0ZLNIxRjJ4ZgQWsvnIQibO3g\nqeTaq6ARM5TZRQXnPE9BIhBL8S2U3mNSXedtq+Pbn4t2jspNYP8QZN0TbBLuXrmv\nnZOrqIX9qD+cCiQCA4aUxvB4twKBgQC38v+BvwNzeOpDJZATsstrbkx0Lb9AQP9z\n+j1CZYAH0GbindqiznTFzA66WKmuDROOsGdSsASMXbKufTTV5x9gqeTHnVz8ALSn\nhFsTqQyMhSJnogCtkFejtnJKRKXYPPRUkRDcnl00dVV+kN1aVnBkauXppeAB/5G5\nOEm7rgxk2wKBgBjySQi0/edZW60sf0TfEGlo47/t4b/ldI1YL0xPlIUsaC/DjDml\nFje9J/dlFfrFIcMDPBL5Wcxv47RrQtdECez/XUXZ1rmEYhY9dhd1Q5QEI1KgsTnS\nThOZp2aJTXSfPv5oF3ENDEuMB4QbPt6W9IWO1nKsUETQKYL44UQXurBRAoGASrP1\njcR7604knOZJT6ahs9xUUi4t6DM9SuVKMYe06fd5gPioTMvZYmaPaKAPMK8AzUbY\nfx0ai8KViQUyCthUxtXYIjTHCVRkCU/YCPDzNrHumfWRnurqnILAgWbFjz6Z3yoW\nlfH+Wgp4kPDV5BUMictb2XpSsZ0Pmg/A6eYyBFcCgYApDDv3McK3hZRPQHaB6f4o\nkrzfS90wzDxw74zGhe9xqkk0/IYXh/P6jZhVwoL36ZjCPf1/nESX/iwsxZlToFcK\ny1T8VXQIhxfiZ+i/bll08cnCR5qBDIVkc+IKde1uqL7uSxquanPuclUp/KXwW4Vk\nyNdI3m0whfk6XppxPD2o6g==\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-fbsvc@personalwellness-192da.iam.gserviceaccount.com",
          "client_id": "110408254704749511129",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40personalwellness-192da.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
      ),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }

  // Print server key to console
  Future<void> printServerKeyToConsole() async {
    try {
      final key = await serverToken();
      print('Server Key: $key');
    } catch (e) {
      print('Error fetching server key: $e');
    }
  }
}