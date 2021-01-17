# Dependencies
# - brew install gnu-sed

FILES='content/posts/*.md'
prefix='[[:digit:]][[:digit:]][[:digit:]][[:digit:]]-[[:digit:]][[:digit:]]-[[:digit:]][[:digit:]]-'
suffix='.md'

for f in $FILES
do
  r=$(basename $f)
  r=$(echo $r | sed -e "s/^$prefix//" -e "s/$suffix$//")
  echo "slug: $r"
  gsed -i "3islug: $r" $f
done
