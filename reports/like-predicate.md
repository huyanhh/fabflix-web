### Project specific requirements

Our queries use: 'ABC%': All strings that start with 'ABC'. For example, 'ABCD' and 'ABCABC' would both satisfy the condition.

Search:
First we append "%" to the end of each GET variable which will be used for LIKE in the query. We get the variables from
the url parameters. Then we execute the query.