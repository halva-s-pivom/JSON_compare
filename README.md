# test-task

## How to run the program:
1) Julia language must be installed (1.6.2 used)
2) JSON, StringCases libraries are required. Add them via `pkg>add JSON StringCases#master`
3) program runs as a script from shell
`$ julia <path/to/test.jl> <path/to/1.json> <path/to/2.json>`
		
Due to JIT compilation a little time delay may occur.
## Output format:
Console log
## Algorithm description:
It's obvious to use a dictionary(hash table) in this approach. Another dictionary may occur inside the given(as a value) --- this case can be processed as well. First of all we need to normalize the input data:
1. all the keys are snake cased now, e.g.:
2. abcAbc turns into abc_abc
3. This is vital for slightly distinct keys which are supposed to be the same, i.e. if we have abcAbc key in the 1 file and abc_abc in the 2 one then there is no difference between them.
		
After normalization we may face next distinctions in JSONs:
1. same keys, different values
2. first json has a key that second does not
3. secont json has a key that first does not
			
This order describes the output
		
Asymptotic upper bound:
O(n), O(n^2) in worst case(set difference; n ln n actually). It's polynomial time anyway, not (sub)exp.
		
## Test:
	
File-A.json
```json
{
    "firstName": "John",
    "lastName": "Smith",
    "isAlive": true,
    "age": 27,
    "address": {
        "streetAddress": "21 2nd Street",
	"city": "New York",
	"state": "NY",
	"postalCode": "10021-3100"
    }
}
```
File-B.json
```json
{
    "first_name": "Alex",
    "lastName": "Smith",
    "isAlive": false,
    "Age": 27,
    "address": {
        "streetAddress": "21 2nd Street",
	"city": "Chicago",
	"state": "IL"
    }
}
```
Output:
````
is_alive:
	First has value true
	Second has value false
first_name:
	First has value John
	Second has value Alex
address:
	First and second are jsons:
		First has key postal_code that second doesn't have
		city:
		    First has value New York
		    Second has value Chicago
		state:
		    First has value NY
		    Second has value IL
