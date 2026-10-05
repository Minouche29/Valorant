# Signer Strike Protocol sans Mac

Le projet est préparé pour Codemagic avec le Bundle ID :

`com.gabrielprunier.strikeprotocol2026`

Deux workflows sont fournis dans `codemagic.yaml` :

- `strikeprotocol-testflight` : IPA signée App Store/TestFlight.
- `strikeprotocol-adhoc` : IPA Ad Hoc installable uniquement sur les appareils enregistrés dans ton compte Apple Developer.

## 1. Créer l'identifiant de l'app chez Apple

Dans Apple Developer > Certificates, Identifiers & Profiles > Identifiers, crée un nouvel **App ID** avec :

`com.gabrielprunier.strikeprotocol2026`

Si Apple indique que cet identifiant est déjà utilisé, remplace-le dans **les deux endroits** suivants du projet :

- `StrikeProtocol.xcodeproj/project.pbxproj`
- `codemagic.yaml`

## 2. Créer une clé App Store Connect pour Codemagic

Dans App Store Connect > Users and Access > Integrations > App Store Connect API :

1. Crée une clé nommée `codemagic`.
2. Donne-lui le rôle **App Manager**.
3. Note le **Issuer ID** et le **Key ID**.
4. Télécharge le fichier `.p8` et conserve-le privé. Ne l'envoie pas dans un chat.

## 3. Connecter Apple Developer à Codemagic

Dans Codemagic :

1. Team settings > Integrations > Developer Portal.
2. Ajoute une clé avec le nom exact `codemagic`.
3. Entre le Issuer ID et le Key ID.
4. Téléverse le `.p8` directement dans Codemagic.

Puis dans Team settings > Code signing identities :

1. Génére ou importe un certificat **Apple Distribution**.
2. Récupère/crée un provisioning profile correspondant au Bundle ID.

Pour **TestFlight/App Store**, utilise un profil App Store.

Pour **Ad Hoc**, enregistre d'abord l'UDID de ton iPhone dans Apple Developer > Devices puis crée/récupère un profil Ad Hoc contenant cet iPhone.

## 4. Mettre le projet dans un dépôt Git

Codemagic lit `codemagic.yaml` depuis la racine du dépôt. Mets le contenu de ce dossier dans GitHub, GitLab ou Bitbucket, puis ajoute le dépôt dans Codemagic.

## 5. Lancer la compilation

Dans Codemagic, sélectionne :

- **Strike Protocol - TestFlight/App Store IPA** pour TestFlight/App Store ; ou
- **Strike Protocol - Direct Install Ad Hoc IPA** pour une IPA directe.

Au terme d'un build réussi, l'IPA apparaît dans **Artifacts**.

## Important

Le fichier `.p8`, les certificats et leurs mots de passe sont des secrets. Ils doivent être saisis directement dans Apple/Codemagic et ne doivent pas être ajoutés dans ce ZIP ou dans un dépôt Git.
