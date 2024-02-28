---
title: How to get the questionnaire JSON file
---

There are two methods for getting the questionnaire JSON file:

1. [Download it with exported data](#download-it-with-exported-data)
2. [Download it with the API](#download-it-with-the-api)

## Download it with exported data

When exporting  data from Survey Solutions, select `Include meta information about questionnaire` under the `Questionnaire information` heading.

Once data have been downloaded, unpack `content.zip` and find the `document.json` file. See more [here](https://docs.mysurvey.solutions/headquarters/export/metadata-organization/) on how to find these files.

This is the JSON file needed for the next step in the workflow.

## Download it with the API

Use some tool to fetch the JSON file from the Survey Solutions' `GET ​/api​/v1​/questionnaires​/{id}​/{version}​/document` endpoint.

Consider using a function from an API client. [Here](https://arthur-shaw.github.io/susoapi/reference/get_questionnaire_document.html) is one such function.
