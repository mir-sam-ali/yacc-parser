
# Parser for C variable declaration statements.

- Accepts simple C programs with variable declarations of type int, char and float in C
language. 
- Declarations include:
  - variables declarations,
  - array declarations of any dimensions
- Creates a syntax tree on accepting the input.
## Grammar Symbols

- Start: decl
- Non-Terminals:
  - decl
  - dec
  - TYPE
  - VARLIST
  - VAR
  - VARID
  - ARRAYDECL
  - ARRAYDEC
  - NUM
- Terminals:
  - ID
  - '['
  - ']'
  - ';'
  - int
  - float
  - char
  - number
  - ','
  
## Grammar Productions

```bash
decl      ->  dec SCOL
decl      ->  decl dec SCOL
dec       ->  TYPE VARLIST
VARLIST   ->  VAR | VARLIST COMMA VAR
VAR       ->  VARID | VARID ARRAYDECL
ARRAYDECL ->  ARRAYDEC | ARRAYDECL ARRAYDEC 
ARRAYDEC  ->  LSB NUM RSB
NUM       ->  NUMBER
VARID     ->  ID
TYPE      ->  int | char | float
```

## Output Format
For each input declaration statement, it is shown whether the statement is accepted or not.

Then, the properties of each variable/array in declaration statement is shown in the following way:

```bash
<type> --> <variable_name> --> <size> --> <array/variable>
```
### Example:
input: int x, y, z, a[10];

output:
```bash
Declaration Statement Accepted.

integer --> x --> '4 Bytes' --> variable
integer --> y --> '4 Bytes' --> variable
integer --> z --> '4 Bytes' --> variable
integer --> a[10] --> '40 Bytes' --> array
```
## References
- Aho - Compilers - Principles, Techniques, and Tools.

## Execution

Clone this repository

```bash
git clone https://github.com/mir-sam-ali/yacc-parser
```

Open the cloned repository and run the following commands:

- make -f Makefile.f
- ./myparser TEST_FILE_NAME
