#!/bin/bash
appledoc \
--project-name "MAFActionSheetController" \
--project-company "Magic App Factory" \
--company-id "com.magicappfactory" \
--ignore ".m" \
--create-html \
--create-docset \
--docset-platform-family "iphoneos" \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--output ~/source/shared/jedlewison.github.io/MAFActionSheetController/ \
MAFActionSheetController
