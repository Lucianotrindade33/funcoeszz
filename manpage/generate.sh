#!/bin/bash
# 2010-12-23
# Aurelio Jargas
#
# Generate the Funcoes ZZ manpage from the Git sources, in txt2tags format.
# It uses the --help of each function to compose the contents.
#
# Note: The manpage.t2t file is also used in the website for zzajuda.html.
#
# Requires: txt2tags

zz=./funcoeszz.tmp
out=manpage.t2t

cd $(dirname "$0") || exit 1

# The all-in-one script is *way* faster to load
echo "Generating funcoeszz script..."
ZZOFF= ZZDIR=../zz ../funcoeszz --tudo-em-um > $zz
chmod +x $zz

(
echo "Funções ZZ


%!target:man
%!encoding:utf-8
%!options(html): --toc
%!options(man): -o manpage.man
%!postproc(man): '^  ' ''
"

export ZZCOR=0
for func in $("$zz" zzajuda --lista | cut -d ' ' -f 1)
do
	echo $func >&2  # informative
	
	echo "= $func =[$func]"
	echo '```'
	"$zz" $func -h | sed 1,2d
	echo '```'
done

) > "$out"
echo
echo "saved $out"

rm $zz

# Convert to man format
txt2tags "$out"

# Create the iso-8859-1 version in man format
# iconv -f utf-8 -t iso-8859-1 manpage-utf8.man > manpage-latin1.man

# Convert to HTML
# txt2tags -t html "$out"
