if [ $# -lt 4 ] ;then
    echo "Usage: <github token> <org/repo> <filename> <version or 'latest'>"
    exit 1
fi

TOKEN="$1"
REPO="$2"
FILE="$3"      # the name of your release asset file, e.g. build.tar.gz
VERSION=$4                       # tag name or the word "latest"
GITHUB_API_ENDPOINT="api.github.com"

alias errcho='>&2 echo'

function gh_curl() {
  curl -sL -H "Authorization: token $TOKEN" \
       -H "Accept: application/vnd.github.v3.raw" \
       $@
}

if [ "$VERSION" = "latest" ]; then
  # Github should return the latest release first.
  PARSER=".[0].assets | map(select(.name == \"$FILE\"))[0].id"
else
  PARSER=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"
fi

ASSET_ID=`gh_curl https://$GITHUB_API_ENDPOINT/repos/$REPO/releases | jq "$PARSER"`
if [ "$ASSET_ID" = "null" ]; then
  errcho "ERROR: version not found $VERSION"
  exit 1
fi

curl -L -H "Accept:  application/octet-stream" \
        -H "Authorization: Bearer $TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://$GITHUB_API_ENDPOINT/repos/$REPO/releases/assets/$ASSET_ID > $FILE