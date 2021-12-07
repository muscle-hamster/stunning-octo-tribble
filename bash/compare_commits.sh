#!/bin/bash

ORGANIZATION=hashicorp
REPOSITORY=terraform
HEAD_COMMIT='v1.0.11'
BASE_COMMIT='v1.1.0-rc1'
OUTPUT_FILE='output.json'

compare()
{
  verifyParams

  curl -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/${ORGANIZATION}/${REPOSITORY}/compare/${HEAD_COMMIT}...${BASE_COMMIT} \
    | jq -r '..|.commit? // empty | {author: .author.name, commit_date:.author.date, commit_url: .url, commit_message: .message}' \
    | awk 'BEGIN { print "[";} {print $0} END { print "]" }' \
    | sed -z 's/}\n{/},\n{/g' >> "$OUTPUT_FILE"
}

verifyParams() {
  if [ -z $ORGANIZATION ]; then echo "The organization flag is empty. This flag must be set."; exit 1; fi
  if [ -z $REPOSITORY ]; then echo "The repository flag is empty. This flag must be set."; exit 1; fi
  if [ -z $HEAD_COMMIT ]; then echo "The head commit flag is empty. This flag must be set."; exit 1; fi
  if [ -z $BASE_COMMIT ]; then echo "The base commit flag is empty. This flag must be set."; exit 1; fi
  if [ -z $OUTPUT_FILE ]; then echo "The output file flag is empty. This flag must be set."; exit 1; fi
}

main()
{
 case "$ACTION" in
   compare)     compare;;
   test)        deleteNodePool;;
 esac
}

usage()
{
  echo "Valid Flags include [c,n,q,m,h]:"
  echo "-o | Name of the GitHub organization"
  echo "-f | Name of file to output results to. Results will be in JSON"
  echo "-r | Name of the repository"
  echo "-h | Head commit"
  echo "-b | Base commit"
  echo "-h | Help"
}

error()
{
  echo "invalid flag"
  exit 1
}

while [ "$1" != "" ]; do
  case $1 in
    compare )            ACTION=$1;;
    test )               ACTION=$1;;
    -o | --org  )        shift; ORGANIZATION=$1;;
    -f | --file  )       shift; OUTPUT_FILE=$1;;
    -r | --repo )        shift; REPOSITORY=$1;;
    -h | --head )        shift; HEAD_COMMIT=$1;;
    -b | --base )        shift; BASE_COMMIT=$1;;
    -h | --help )        usage; exit;;
    * )                  error; exit 1
  esac
  shift
done

main
