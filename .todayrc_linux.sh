#!/bin/bash
## Crafted (c) 2013~2017 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc_linux.sh
## Version  : PA07
## Date     : 2017-11-20
## Project  : project-things-today
## Reference: bash
##
## Purpose  : Develop a system in order to help TODAY management directory
##            for projects.

# set -x

tag() {
  case $1 in
    -l)
      if [ $2 == "." ]; then
        local P=`basename "$PWD"`
      else
        local P=`basename "$2"`
      fi
      grep $P $TAGSFILE
      ;;
    -lN)
      if [ $2 == "." ]; then
        local P=`basename "$PWD"`
      else
        local P=`basename "$2"`
      fi
      grep $P $TAGSFILE | awk '{print $2}'
      ;;
    -a)
      if [ $3 == "." ]; then
        local P=`basename "$PWD"`
      else
        local P=`basename "$3"`
      fi
      local PROJNAME=(`grep $P $TAGSFILE | awk '{print $1}'`)
      if [ -z $PROJNAME ]; then
        TAGS=(`echo $2 | sed 's/,/ /g'`)
        TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
        TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
        echo -e "$P $TAGS" >> $TAGSFILE
      else
        local TAGS=(`grep $P $TAGSFILE | awk '{print $2}' | sed 's/,/ /g'`)
        TAGS+=(`echo $2 | sed 's/,/ /g'`)
        TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
        TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
        sed -i "/$P.*/c $P $TAGS" $TAGSFILE
      fi
      ;;
    -r)
      if [ $3 == "." ]; then
        local P=`basename "$PWD"`
      else
        local P=`basename "$3"`
      fi
      local TAGS=(`grep $P $TAGSFILE | awk '{print $2}' | sed 's/,/ /g'`)
      local TAGSDEL=(`echo $2 | sed 's/,/ /g'`)
      for del in ${TAGSDEL[@]}
      do
        TAGS=("${TAGS[@]/$del}") #Quotes when working with strings
      done
      TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
      TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
      sed -i "/$P.*/c $P $TAGS" $TAGSFILE
      ;;
    -m)
      local TAGS=(`echo $2 | sed 's/,/ /g'`)
      while read line; do
        local PROJTAGS=(`echo $line | awk '{print $2}' | sed 's/,/ /g'`)
        local PROJNAME=(`echo $line | awk '{print $1}'`)
        for _tag in ${TAGS[@]}
        do
          if [ $(__contains "${PROJTAGS[@]}" "$_tag") == "y" ]; then
            echo "$PROJNAME"
          fi
        done
      done < $TAGSFILE
      ;;
  esac
}
