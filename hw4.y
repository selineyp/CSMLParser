
%{

	#include "hw4.h"
	#include <string.h>
	#include <stdlib.h> 
        #include <stdio.h>
    	int mainListindex =0;
	int crnlistindex=0;
	int codelistindex=0;
	TreeNode* mainList[80];

#define  MAX_ARR_SIZE 80
#define  NUM_STRING 80
char codelist [NUM_STRING][MAX_ARR_SIZE];
int crnlist [MAX_ARR_SIZE];

void printTree();
char *tabmaker(int cnt);
void printClass(ClassNode *cl);
void printMeetingAttr(MeetingAttrNode *c1);
void printCourseAttr(CourseAttrNode *c1);
void printMeeting(MeetingNode* m);
void printMeetings(MeetingNode * m);
void printClassAttr(ClassAttrNode* c);
void printClasses(ClassNode *c);
void printItem(ItemNode *i);
void printCourse(CourseNode *c);
void printCourses(CourseNode *c);
void printConstraint(ItemNode *i);

CourseAttrNode * mkcourseAttrcode(char*);
CourseAttrNode * mkcourseAttrtype(char*);
CourseAttrNode * mkcourseAttrname(char*);

CourseAttrNode * mkcourseAttrList(CourseAttrNode*,CourseAttrNode*);
ClassAttrNode * mkclassAttrcrn(int);
ClassAttrNode * mkclassAttrcapacity(int);
ClassAttrNode * mkclassAttrsection(char*);
ClassAttrNode * mkclassAttrinstructor(char*);

ItemAttrNode * mkitemAttrcrn(int);
ItemAttrNode * mkitemAttrcode(char*);

ClassAttrNode * mkclassAttrList(ClassAttrNode*,ClassAttrNode*);

MeetingAttrNode * mkmeetingAttrstart(char*);
MeetingAttrNode * mkmeetingAttrday(char*);
MeetingAttrNode * mkmeetingAttrend(char*);
MeetingAttrNode * mkmeetingAttrList(MeetingAttrNode*,MeetingAttrNode*);

CourseNode * mkcourseList();
CourseNode * mkcourse();
TreeNode * mkcourseelement(CourseNode * c);
TreeNode * mkitemelement(ItemNode* i);
ClassNode * mkclass(ClassAttrNode *c, MeetingNode *m);
ItemNode * mkitem(ItemAttrNode *i);
ItemNode * mkitemList();
TreeNode  *mkconstraint(ItemNode* i);
ClassNode * mkclassList();
MeetingNode * mkmeeting(MeetingAttrNode *m);
MeetingNode * mkmeetingList();
int tabcnt=0;
int foundError=0;
char *tabmaker(int cnt){
    char *str = (char *) malloc(cnt);
    for(int i=0;i<cnt;i++)
		str[i]='\t';
    return str;
}

	void code_not_found_error(const char *s,int lineno){
		printf("ERROR: constraint at line %d refers to an undefined code= %s\n",lineno, s);
		foundError=1;
	}
	void multiple_attr_error(const char * elttype, const char* attr,int occ,int lineno){
		printf("ERROR: %s element at line %d has %d occurrences of %s \n",elttype,lineno,occ,attr);
		foundError =1;
	}
	void crn_not_found_error(int crn,int lineno){
		printf("ERROR: constraint at line %d refers to an undefined crn= %d\n", lineno,crn);
		foundError=1;
	}
	void yyerror(const char *s){printf("%s\n", s);}
void add_to_crnlist(int i);
void add_to_codelist(char* c);
void codelookup(char* c);
void crnlookup(int i);
void checkcourseAttr(CourseAttrNode* c);
void checkclassAttr(ClassAttrNode* c);
void checkmeetingAttr(MeetingAttrNode* c);

%}


%union{
char *str;
int value;
CourseAttrNode *courseAttrPtr;
ClassAttrNode *classAttrPtr;
MeetingAttrNode *meetingAttrPtr;
ItemAttrNode *itemAttrPtr;
CourseNode *coursePtr;
ItemNode *itemPtr;
ClassNode *classPtr;
MeetingNode *meetingPtr;
}

%token EOE
%token NUM
%token STRING
%token TIME
%token tMON
%token tTUE
%token tWED
%token tTHU
%token tFRI
%type <value> NUM
%type <str> TIME
%type <str> STRING
%type <courseAttrPtr> courseAttrList
%type <itemAttrPtr> itemAttr
%type <classAttrPtr> classAttrList
%type <courseAttrPtr> courseAttr
%type <classAttrPtr> classAttr
%type <meetingAttrPtr> meetingAttr
%type <meetingAttrPtr> meetingAttrList
%type <classPtr> class
%type <classPtr> classList
%type <meetingPtr> meeting
%type <meetingPtr> meetingList
%type <itemPtr> item
%type <itemPtr> itemList
%type <coursePtr> element
%type <courseAttrPtr> beginCourse
%type <str> tMON
%type <str> tTUE
%type <str> tWED
%type <str> tTHU
%type <str> tFRI
%type <str> day
%token tOPEN tCOURSE tCLOSE tEND tCRN tCODE tCLASS tSECTION tINSTRUCTOR tTYPE tNAME tCAPACITY tMEETING tSELF tDAY tSTART  tEND_A  tCONSTRAINT tITEM 
%locations
%% 
prog : elementList |  ;
courseAttrList :  courseAttr {$$ = $1;}
                  |courseAttr courseAttrList {$$ = mkcourseAttrList($1,$2);};

courseAttr : tCODE STRING {add_to_codelist($2);
              $$ = mkcourseAttrcode($2);
}
	| tTYPE STRING  {$$ = mkcourseAttrtype($2);
}
	| tNAME STRING  {$$ = mkcourseAttrname($2);};

beginCourse : tOPEN tCOURSE  courseAttrList tCLOSE{$$ = $3;checkcourseAttr($3);};
endCourse : tEND tCOURSE tCLOSE;
elementList :  element | element elementList;

element :  beginCourse classList endCourse{ mainList[mainListindex]=mkcourseelement(mkcourse($1,$2));mainListindex+=1; }
	 | beginConstraint itemList endConstraint{ mainList[mainListindex]=mkitemelement($2);mainListindex+=1; };

classList : class{$$ = $1;} | class classList {$$ = mkclassList($1,$2);
};
class :  beginClass classAttrList endClass meetingList closeClass{$$ = mkclass($2,$4);checkclassAttr($2);};
beginClass  : tOPEN tCLASS ;
closeClass : tEND tCLASS tCLOSE ;
endClass :  tCLOSE  ;

classAttrList :  classAttr {$$ = $1;} | classAttr classAttrList {$$ = mkclassAttrList($1,$2);};
classAttr : tSECTION STRING  {$$ = mkclassAttrsection($2); }
|  tINSTRUCTOR STRING  {$$ = mkclassAttrinstructor($2); }
| tCRN NUM {add_to_crnlist($2); 
$$ = mkclassAttrcrn($2);
}
| tCAPACITY NUM {$$ = mkclassAttrcapacity($2);
};


itemList :  item {$$ = $1;} | item itemList {$$ = mkitemList($1,$2);};
item :  beginItem itemAttr endItem {$$ = mkitem($2);};
beginItem : tOPEN tITEM;
endItem : tSELF;
itemAttr: tCODE STRING {$$ = mkitemAttrcode($2);codelookup($2);
}
	| tCRN NUM {$$ = mkitemAttrcrn($2);crnlookup($2);
};

meetingList : meeting {$$=$1;}|meeting  meetingList{$$ = mkmeetingList($1,$2);
};
meeting : beginMeeting meetingAttrList endMeeting{$$ = mkmeeting($2);checkmeetingAttr($2);};
beginMeeting :  tOPEN tMEETING;
endMeeting :tSELF;
meetingAttrList : meetingAttr {$$ = $1;}
		 | meetingAttr meetingAttrList {$$ = mkmeetingAttrList($1,$2);};

meetingAttr : tDAY day {$$ = mkmeetingAttrday($2);}
		|tSTART TIME {$$ = mkmeetingAttrstart($2);}
		| tEND_A TIME {$$ = mkmeetingAttrend($2);
};

day : tMON  {$$ = $1;} | tTUE {$$ = $1;}  | tWED  {$$ = $1;} | tTHU {$$ = $1;} | tFRI {$$ = $1;};
beginConstraint : tOPEN tCONSTRAINT tCLOSE;
endConstraint : tEND tCONSTRAINT  tCLOSE;

%%

void printMeeting(MeetingNode* m){
	printf("%s",tabmaker(tabcnt));
	printf("<meeting");
	        meetingAttrListNode mattrs =m->meetingNodePtr->m_meeting.attrs->meetingNodePtr->mAttrList;
		MeetingAttrNode *mleft = mattrs.leftChild;
		MeetingAttrNode *mright = mattrs.rightChild;
		MeetingAttrNode *tmpleft=mleft;
		MeetingAttrNode *tmpright=mright;
		printMeetingAttr(mleft);
		while(tmpright->thisNodeType == mAttrList)
		{
			tmpleft = tmpright->meetingNodePtr->mAttrList.leftChild;
			printMeetingAttr(tmpleft);
			tmpright = tmpright->meetingNodePtr->mAttrList.rightChild;
		}
		printMeetingAttr(tmpright);

        printf("/>\n");
}

void printTree(){

for(int i=0;i<mainListindex;i++){
if(mainList[i]->thisNodeType == courses)
	printCourses(mainList[i]->elementNodePtr->courses);
}
for(int i=0;i<mainListindex;i++){
if(mainList[i]->thisNodeType == items)
	printConstraint(mainList[i]->elementNodePtr->items);
}
}

void printClass(ClassNode *cl){
	        printf("<class");
		classAttrListNode t1 = cl->classNodePtr->m_class.attrs->classNodePtr->clAttrList;
		ClassAttrNode *tmpleft = t1.leftChild;
 		ClassAttrNode *tmpright = t1.rightChild;
 	        printClassAttr(tmpleft);
		while(tmpright->thisNodeType == clAttrList)
		{
			tmpleft = tmpright->classNodePtr->clAttrList.leftChild;
			printClassAttr(tmpleft);
			tmpright = tmpright->classNodePtr->clAttrList.rightChild;
		}
		printClassAttr(tmpright);
		printf(">\n");

		MeetingNode *m = cl->classNodePtr->m_class.meetings;
		printMeetings(m);
		printf("%s",tabmaker(tabcnt));
		printf("</class>");

}
void printClasses(ClassNode *c){
		tabcnt +=1;
		printf("%s",tabmaker(tabcnt));
		if(c->thisNodeType == m_classList){
		ClassNode * c1 = c->classNodePtr->m_classList.leftChild;
		ClassNode * c2 = c->classNodePtr->m_classList.rightChild;
		ClassNode *tmp1 = c1;
		ClassNode *tmp2 = c2;
		printClass(tmp1);
		while(tmp2->thisNodeType == m_classList)
		{
			tmp1 = tmp2->classNodePtr->m_classList.leftChild;
			printClass(tmp1);
			tmp2 = tmp2->classNodePtr->m_classList.rightChild;
		}
		printClass(tmp2);
	}
	else printClass(c);
	tabcnt -=1;
	printf("%s",tabmaker(tabcnt));
}



void printItem(ItemNode *i){
		ItemAttrNode * c3 = i->itemNodePtr->m_item.attrs;
		printf("%s",tabmaker(tabcnt));
		printf("<item");
		if(c3->thisNodeType == iAttrcode ){printf(" code=%s", c3->itemNodePtr->iAttrcode.code);}
		if(c3->thisNodeType == iAttrcrn ){printf(" crn=%s", c3->itemNodePtr->iAttrcrn.crn);}
		printf("/>\n");
		
}
void printConstraint(ItemNode *i){
		printf("<constraint>\n");
		tabcnt +=1;
	        if(i->thisNodeType == m_itemList){
		ItemNode * c1 = i->itemNodePtr->m_itemList.leftChild;
		ItemNode * c2 = i->itemNodePtr->m_itemList.rightChild;
		ItemNode *tmp1 = c1;
		ItemNode *tmp2 = c2;
		printItem(tmp1);
		while(tmp2->thisNodeType == m_itemList)
		{
			tmp1 = tmp2->itemNodePtr->m_itemList.leftChild;
			printItem(tmp1);
			tmp2 = tmp2->itemNodePtr->m_itemList.rightChild;
		}
		printItem(tmp2);
	}
	else printItem(i);
	tabcnt -=1;
	printf("%s",tabmaker(tabcnt));
	printf("</constraint>\n");	
}


void printMeetingAttr(MeetingAttrNode *c1){
		if(c1->thisNodeType == mAttrday)printf(" day=%s", c1->meetingNodePtr->mAttrday.day);
	        if(c1->thisNodeType == mAttrstart)printf(" start=%s", c1->meetingNodePtr->mAttrstart.start);
 		if(c1->thisNodeType == mAttrend)printf(" end=%s", c1->meetingNodePtr->mAttrend.end);
}

void printCourseAttr(CourseAttrNode *c1){
		if(c1->thisNodeType == cAttrname)printf(" name=%s", c1->courseNodePtr->cAttrname.name);
	        if(c1->thisNodeType == cAttrtype)printf(" type=%s", c1->courseNodePtr->cAttrtype.type);
 		if(c1->thisNodeType == cAttrcode)printf(" code=%s", c1->courseNodePtr->cAttrcode.code);
}



void printClassAttr(ClassAttrNode* c){
 		if(c->thisNodeType == clAttrsection)printf(" section=%s", c->classNodePtr->clAttrsection.section);
	        if(c->thisNodeType == clAttrinstructor)printf(" instructor=%s", c->classNodePtr->clAttrinstructor.instructor);
 		if(c->thisNodeType == clAttrcrn)printf(" crn=%s", c->classNodePtr->clAttrcrn.crn);

}


void printCourse(CourseNode *c){
	        printf("<course");
		courseAttrListNode t1 = c->courseNodePtr->m_course.attrs->courseNodePtr->cAttrList;
		CourseAttrNode *tmpleft = t1.leftChild;
 		CourseAttrNode *tmpright = t1.rightChild;
 	        printCourseAttr(tmpleft);
		while(tmpright->thisNodeType == cAttrList)
		{
			tmpleft = tmpright->courseNodePtr->cAttrList.leftChild;
			printCourseAttr(tmpleft);
			tmpright = tmpright->courseNodePtr->cAttrList.rightChild;
		}
		printCourseAttr(tmpright);
		printf(">\n");

		ClassNode *cl = c->courseNodePtr->m_course.classes;
		printClasses(cl);
		printf("\n</course>\n");

}

void printCourses(CourseNode *c){
		if(c->thisNodeType == m_courseList){
		CourseNode * c1 = c->courseNodePtr->m_courseList.leftChild;
		CourseNode * c2 = c->courseNodePtr->m_courseList.rightChild;
		CourseNode *tmp1 = c1;
		CourseNode *tmp2 = c2;
		printCourse(tmp1);
		while(tmp2->thisNodeType == m_courseList)
		{
			tmp1 = tmp2->courseNodePtr->m_courseList.leftChild;
			printCourse(tmp1);
			tmp2 = tmp2->courseNodePtr->m_courseList.rightChild;
		}
		printCourse(tmp2);
	}
	else printCourse(c);
		
}

/*

CourseAttrNode * mkcourseAttrList (CourseAttrNode *left, CourseAttrNode *right) {
	CourseAttrNode * ret	= (CourseAttrNode *)malloc (sizeof(CourseAttrNode));
	ret->thisNodeType = cAttrList;
	ret->courseNodePtr = (courseAttrsNode *)malloc (sizeof(courseAttrsNode));
        
	if(right->thisNodeType == cAttrtype)
	{ ret->courseNodePtr->cAttrList.typecount  = 1;
		if(left->thisNodeType == cAttrtype)
		ret->courseNodePtr->cAttrList.typecount += 1; 
		else if (left->thisNodeType == cAttrname)
		ret->courseNodePtr->cAttrList.namecount  = 1;
		else
		ret->courseNodePtr->cAttrList.codecount  = 1;
       }
	else if(right->thisNodeType == cAttrname)
	{ ret->courseNodePtr->cAttrList.namecount  = 1;
		if(left->thisNodeType == cAttrtype)
		ret->courseNodePtr->cAttrList.typecount = 1; 
		else if (left->thisNodeType == cAttrname)
		ret->courseNodePtr->cAttrList.namecount  += 1;
		else
		ret->courseNodePtr->cAttrList.codecount  = 1;
       }
	else if(right->thisNodeType == cAttrcode)
	{ ret->courseNodePtr->cAttrList.codecount  += 1;
		if(left->thisNodeType == cAttrtype)
		ret->courseNodePtr->cAttrList.typecount = 1; 
		else if (left->thisNodeType == cAttrname)
		ret->courseNodePtr->cAttrList.namecount  = 1;
		else
		ret->courseNodePtr->cAttrList.codecount  += 1;
       }
        
	else if(right->thisNodeType == cAttrList)
	{
	ret->courseNodePtr->cAttrList.typecount  = right->courseNodePtr->cAttrList.typecount;
	ret->courseNodePtr->cAttrList.namecount  = right->courseNodePtr->cAttrList.namecount;
	ret->courseNodePtr->cAttrList.codecount  = right->courseNodePtr->cAttrList.codecount;

	if(left->thisNodeType == cAttrtype)
	ret->courseNodePtr->cAttrList.typecount  +=1;
        if(left->thisNodeType == cAttrname)
	ret->courseNodePtr->cAttrList.namecount +=1;
        if(left->thisNodeType == cAttrcode)
	ret->courseNodePtr->cAttrList.codecount  +=1;
        }
	ret->courseNodePtr->cAttrList.leftChild = left;
	ret->courseNodePtr->cAttrList.rightChild = right;
	return (ret);
}


CourseAttrNode * mkcourseAttrcode (char *code) {
        
	CourseAttrNode * ret= (CourseAttrNode *)malloc (sizeof(CourseAttrNode));
        ret->thisNodeType = cAttrcode;
	ret->courseNodePtr = (courseAttrsNode *)malloc (sizeof(courseAttrsNode));
	ret->courseNodePtr->cAttrcode.code = code;
	return (ret);
}
CourseAttrNode * mkcourseAttrtype (char *type) {
        
	CourseAttrNode * ret= (CourseAttrNode *)malloc (sizeof(CourseAttrNode));
        ret->thisNodeType = cAttrtype;
	ret->courseNodePtr = (courseAttrsNode *)malloc (sizeof(courseAttrsNode));
	ret->courseNodePtr->cAttrtype.type = type;
	return (ret);
}

TreeNode * mkcourseelement(CourseNode * c){
	TreeNode * ret= (TreeNode *)malloc (sizeof(TreeNode));
	ret->elementNodePtr = (ElementNode *)malloc (sizeof(ElementNode));
	ret->elementNodePtr->courses = (CourseNode *)malloc (sizeof(CourseNode));
	ret->elementNodePtr->courses =  c;
        ret->thisNodeType = courses;
	return (ret);
	}

TreeNode * mkitemelement(ItemNode * i){
	TreeNode * ret= (TreeNode *)malloc (sizeof(TreeNode));
	ret->elementNodePtr = (ElementNode *)malloc (sizeof(ElementNode));
	ret->elementNodePtr->items = (ItemNode *)malloc (sizeof(ItemNode));
	ret->elementNodePtr->items = i;
        ret->thisNodeType = items;
	return (ret);
	}

CourseAttrNode * mkcourseAttrname (char *name) {
        
	CourseAttrNode * ret= (CourseAttrNode *)malloc (sizeof(CourseAttrNode));
        ret->thisNodeType = cAttrname;
	ret->courseNodePtr = (courseAttrsNode *)malloc (sizeof(courseAttrsNode));
	ret->courseNodePtr->cAttrname.name = name;
	return (ret);
}

ClassAttrNode * mkclassAttrsection (char *section) {
        
	ClassAttrNode * ret	= (ClassAttrNode *)malloc (sizeof(ClassAttrNode));
        ret->thisNodeType = clAttrsection;
	ret->classNodePtr = (classAttrsNode *)malloc (sizeof(classAttrsNode));
	ret->classNodePtr->clAttrsection.section = section;
	return (ret);
}
ClassAttrNode * mkclassAttrcrn (int crn) {
        
	ClassAttrNode * ret	= (ClassAttrNode *)malloc (sizeof(ClassAttrNode));
        ret->thisNodeType = clAttrcrn;
	ret->classNodePtr = (classAttrsNode *)malloc (sizeof(classAttrsNode));
	char *tmp=malloc(32);
        sprintf(tmp, "%d", crn);
	ret->classNodePtr->clAttrcrn.crn= tmp;
	return (ret);
}

ItemAttrNode * mkitemAttrcrn (int crn) {
        
	ItemAttrNode * ret	= (ItemAttrNode *)malloc (sizeof(ItemAttrNode));
        ret->thisNodeType = iAttrcrn;
	ret->itemNodePtr = (itemAttrsNode *)malloc (sizeof(itemAttrsNode));
	char *tmp=malloc(32);
        sprintf(tmp, "%d", crn);

	ret->itemNodePtr->iAttrcrn.crn= tmp;
	return (ret);
}
ItemAttrNode * mkitemAttrcode (char *code) {
        
	ItemAttrNode * ret	= (ItemAttrNode *)malloc (sizeof(ItemAttrNode));
        ret->thisNodeType = iAttrcode;
	ret->itemNodePtr = (itemAttrsNode *)malloc (sizeof(itemAttrsNode));
	ret->itemNodePtr->iAttrcode.code = code;
	return (ret);
}
ClassAttrNode * mkclassAttrinstructor (char * instructor) {
        
	ClassAttrNode * ret	= (ClassAttrNode *)malloc (sizeof(ClassAttrNode));
        ret->thisNodeType = clAttrinstructor;
	ret->classNodePtr = (classAttrsNode *)malloc (sizeof(classAttrsNode));
	ret->classNodePtr->clAttrinstructor.instructor = instructor;
	return (ret);
}

ClassAttrNode * mkclassAttrcapacity (int capacity) {
        
	ClassAttrNode * ret	= (ClassAttrNode *)malloc (sizeof(ClassAttrNode));
        ret->thisNodeType = clAttrcapacity;
	ret->classNodePtr = (classAttrsNode *)malloc (sizeof(classAttrsNode));
        char *tmp=malloc(32);
 	sprintf(tmp, "%d", capacity); 
	ret->classNodePtr->clAttrcapacity.capacity=tmp;
	return (ret);
}



MeetingAttrNode * mkmeetingAttrday (char *day) {
	MeetingAttrNode * ret= (MeetingAttrNode *)malloc (sizeof(MeetingAttrNode));
        ret->thisNodeType = mAttrday;
	ret->meetingNodePtr = (meetingAttrsNode *)malloc (sizeof(meetingAttrsNode));
	ret->meetingNodePtr->mAttrday.day = day;
	return (ret);
}
MeetingAttrNode * mkmeetingAttrstart (char *start) {
	MeetingAttrNode * ret= (MeetingAttrNode *)malloc (sizeof(MeetingAttrNode));
        ret->thisNodeType = mAttrstart;
	ret->meetingNodePtr = (meetingAttrsNode *)malloc (sizeof(meetingAttrsNode));
	ret->meetingNodePtr->mAttrstart.start = start;
	return (ret);
}

MeetingAttrNode * mkmeetingAttrend (char * end) {
	MeetingAttrNode * ret= (MeetingAttrNode *)malloc (sizeof(MeetingAttrNode));
        ret->thisNodeType = mAttrend;
	ret->meetingNodePtr = (meetingAttrsNode *)malloc (sizeof(meetingAttrsNode));
	ret->meetingNodePtr->mAttrend.end = end;
	return (ret);
}


MeetingAttrNode * mkmeetingAttrList (MeetingAttrNode* left ,MeetingAttrNode* right) {
	MeetingAttrNode * ret	= (MeetingAttrNode *)malloc (sizeof(MeetingAttrNode));
        ret->thisNodeType = mAttrList;
	ret->meetingNodePtr = (meetingAttrsNode *)malloc (sizeof(meetingAttrsNode));

	if(right->thisNodeType == mAttrstart)
	{ ret->meetingNodePtr->mAttrList.startcount  = 1;
		if(left->thisNodeType == mAttrend)
		ret->meetingNodePtr->mAttrList.endcount = 1; 
		else if (left->thisNodeType == mAttrday)
		ret->meetingNodePtr->mAttrList.daycount  = 1;
		else
		ret->meetingNodePtr->mAttrList.startcount  += 1;
       }
	else if(right->thisNodeType == mAttrend)
	{ ret->meetingNodePtr->mAttrList.endcount  = 1;
		if(left->thisNodeType == mAttrday)
		ret->meetingNodePtr->mAttrList.daycount = 1; 
		else if (left->thisNodeType == mAttrstart)
		ret->meetingNodePtr->mAttrList.startcount  = 1;
		else
		ret->meetingNodePtr->mAttrList.endcount  += 1;
       }
        else if(right->thisNodeType == mAttrday)
	{ ret->meetingNodePtr->mAttrList.daycount  = 1;
		if(left->thisNodeType == mAttrday)
		ret->meetingNodePtr->mAttrList.daycount += 1; 
		else if (left->thisNodeType == mAttrstart)
		ret->meetingNodePtr->mAttrList.startcount  = 1;
		else
		ret->meetingNodePtr->mAttrList.endcount  = 1;
       }
	else if(right->thisNodeType == mAttrList)
	{
	ret->meetingNodePtr->mAttrList.startcount  = right->meetingNodePtr->mAttrList.startcount;
	ret->meetingNodePtr->mAttrList.endcount  = right->meetingNodePtr->mAttrList.endcount;
	ret->meetingNodePtr->mAttrList.daycount  = right->meetingNodePtr->mAttrList.daycount;
	if(left->thisNodeType == mAttrday)
	ret->meetingNodePtr->mAttrList.daycount +=1;
        if(left->thisNodeType == mAttrstart)
	ret->meetingNodePtr->mAttrList.startcount +=1;
        if(left->thisNodeType == mAttrend)
	ret->meetingNodePtr->mAttrList.endcount +=1;
        }
	ret->meetingNodePtr->mAttrList.leftChild = left;
	ret->meetingNodePtr->mAttrList.rightChild = right;
	return (ret);
}



ClassNode * mkclass (ClassAttrNode * attrs, MeetingNode *m){
  	ClassNode * ret = (ClassNode *)malloc (sizeof(ClassNode));
        ret->thisNodeType = m_class;
	ret->classNodePtr = (clNode *)malloc (sizeof(clNode));
	ret->classNodePtr->m_class.attrs = attrs;
	ret->classNodePtr->m_class.meetings = m;
	return ret;
}
MeetingNode * mkmeeting (MeetingAttrNode * attrs){
  	MeetingNode * ret = (MeetingNode *)malloc (sizeof(MeetingNode));
        ret->thisNodeType = m_meeting;
	ret->meetingNodePtr = (mNode *)malloc (sizeof(mNode));
	ret->meetingNodePtr->m_meeting.attrs = attrs;
	return ret;
}

CourseNode * mkcourse (CourseAttrNode * attrs, ClassNode * classNode){
  	CourseNode * ret = (CourseNode *)malloc (sizeof(CourseNode));
        ret->thisNodeType = m_course;
	ret->courseNodePtr = (cNode *)malloc (sizeof(cNode));
	ret->courseNodePtr->m_course.attrs = attrs;
	ret->courseNodePtr->m_course.classes = classNode;
	return ret;
}

ItemNode * mkitem (ItemAttrNode * attrs){
  	ItemNode * ret = (ItemNode *)malloc (sizeof(ItemNode));
        ret->thisNodeType = m_item;
	ret->itemNodePtr = (iNode *)malloc (sizeof(iNode));
	ret->itemNodePtr->m_item.attrs = attrs;
	return ret;
}

ClassNode * mkclassList (ClassNode* left, ClassNode* right){
  	ClassNode * ret = (ClassNode *)malloc (sizeof(ClassNode));
        ret->thisNodeType = m_classList;
	ret->classNodePtr = (clNode *)malloc (sizeof(clNode));
	ret->classNodePtr->m_classList.leftChild = left;
	ret->classNodePtr->m_classList.rightChild=right;
	return ret;
}

CourseNode * mkcourseList (CourseNode* left, CourseNode* right){
  	CourseNode * ret = (CourseNode *)malloc (sizeof(CourseNode));
        ret->thisNodeType = m_courseList;
	ret->courseNodePtr = (cNode *)malloc (sizeof(cNode));
	ret->courseNodePtr->m_courseList.leftChild= left;
	ret->courseNodePtr->m_courseList.rightChild=right;
	return ret;
}

ItemNode * mkitemList (ItemNode* left, ItemNode* right){
  	ItemNode * ret = (ItemNode *)malloc (sizeof(ItemNode));
        ret->thisNodeType = m_itemList;
	ret->itemNodePtr = (iNode *)malloc (sizeof(iNode));
	ret->itemNodePtr->m_itemList.leftChild= left;
	ret->itemNodePtr->m_itemList.rightChild=right;
	return ret;
}

MeetingNode * mkmeetingList (MeetingNode* left, MeetingNode* right){
  	MeetingNode * ret = (MeetingNode *)malloc (sizeof(MeetingNode));
        ret->thisNodeType = m_meetingList;
	ret->meetingNodePtr = (mNode *)malloc (sizeof(mNode));
	ret->meetingNodePtr->m_meetingList.leftChild= left;
	ret->meetingNodePtr->m_meetingList.rightChild=right;
	return ret;
}


ClassAttrNode * mkclassAttrList (ClassAttrNode* left ,ClassAttrNode* right) {
	ClassAttrNode * ret	= (ClassAttrNode *)malloc (sizeof(ClassAttrNode));
        ret->thisNodeType = clAttrList;
	ret->classNodePtr = (classAttrsNode *)malloc (sizeof(classAttrsNode));
	
	if(right->thisNodeType == clAttrcapacity)
	{ ret->classNodePtr->clAttrList.capacitycount  = 1;
		if(left->thisNodeType == clAttrcrn)
		ret->classNodePtr->clAttrList.crncount = 1; 
		else if (left->thisNodeType == clAttrsection)
		ret->classNodePtr->clAttrList.sectioncount  = 1;
		else if(left->thisNodeType == clAttrinstructor)
		ret->classNodePtr->clAttrList.instructorcount  = 1;
		else
		ret->classNodePtr->clAttrList.capacitycount  += 1;
       }
	else if(right->thisNodeType == clAttrcrn)
	{ ret->classNodePtr->clAttrList.crncount  = 1;
		if(left->thisNodeType == clAttrcrn)
		ret->classNodePtr->clAttrList.crncount += 1; 
		else if (left->thisNodeType == clAttrsection)
		ret->classNodePtr->clAttrList.sectioncount  = 1;
		else if(left->thisNodeType == clAttrinstructor)
		ret->classNodePtr->clAttrList.instructorcount  = 1;
		else
		ret->classNodePtr->clAttrList.capacitycount  = 1;
       }
	else if(right->thisNodeType == clAttrsection)
	{ ret->classNodePtr->clAttrList.sectioncount  = 1;
		if(left->thisNodeType == clAttrcrn)
		ret->classNodePtr->clAttrList.crncount = 1; 
		else if (left->thisNodeType == clAttrsection)
		ret->classNodePtr->clAttrList.sectioncount  += 1;
		else if(left->thisNodeType == clAttrinstructor)
		ret->classNodePtr->clAttrList.instructorcount  = 1;
		else
		ret->classNodePtr->clAttrList.capacitycount  = 1;
       }
	else if(right->thisNodeType == clAttrinstructor)
	{ ret->classNodePtr->clAttrList.instructorcount  = 1;
		if(left->thisNodeType == clAttrcrn)
		ret->classNodePtr->clAttrList.crncount = 1; 
		else if (left->thisNodeType == clAttrsection)
		ret->classNodePtr->clAttrList.sectioncount  = 1;
		else if(left->thisNodeType == clAttrinstructor)
		ret->classNodePtr->clAttrList.instructorcount  += 1;
		else
		ret->classNodePtr->clAttrList.capacitycount  = 1;
       }
	
     else if(right->thisNodeType == clAttrList)
	{
	ret->classNodePtr->clAttrList.crncount  = right->classNodePtr->clAttrList.crncount;
        ret->classNodePtr->clAttrList.instructorcount  = right->classNodePtr->clAttrList.instructorcount;
	ret->classNodePtr->clAttrList.sectioncount  = right->classNodePtr->clAttrList.sectioncount;
	ret->classNodePtr->clAttrList.capacitycount  = right->classNodePtr->clAttrList.capacitycount;
	if(left->thisNodeType == clAttrcrn)
	ret->classNodePtr->clAttrList.crncount  +=1;
        if(left->thisNodeType == clAttrcapacity)
	ret->classNodePtr->clAttrList.capacitycount +=1;
        if(left->thisNodeType == clAttrsection)
	ret->classNodePtr->clAttrList.sectioncount +=1;
  	if(left->thisNodeType == clAttrinstructor)
	ret->classNodePtr->clAttrList.instructorcount +=1;
        }
    
	ret->classNodePtr->clAttrList.leftChild = left;
	ret->classNodePtr->clAttrList.rightChild = right;
	return (ret);
}


*/
void codelookup(char* c)
{
	for(int k=0;k<codelistindex;k++)
	if(strcmp(codelist[k],c)==0)
	return;
code_not_found_error(c,yylloc.first_line);
}
void crnlookup(int i){
for(int k=0;k<crnlistindex;k++)
	if(crnlist[k]==i)
	return;
crn_not_found_error(i,yylloc.first_line);	
}
void add_to_crnlist(int i)
{
	crnlist[crnlistindex]=i;
	crnlistindex+=1;
}
void add_to_codelist(char* c){

	strcpy(codelist[codelistindex],c);
	codelistindex+=1;
}



void printMeetings(MeetingNode * m){
		tabcnt +=1;
		if(m->thisNodeType == m_meetingList){
		MeetingNode * c1 = m->meetingNodePtr->m_meetingList.leftChild;
		MeetingNode * c2 = m->meetingNodePtr->m_meetingList.rightChild;
		MeetingNode *tmp1 = c1;
		MeetingNode *tmp2 = c2;
		printMeeting(tmp1);
		while(tmp2->thisNodeType == m_meetingList)
		{
			tmp1 = tmp2->meetingNodePtr->m_meetingList.leftChild;
			printMeeting(tmp1);
			tmp2 = tmp2->meetingNodePtr->m_meetingList.rightChild;
		}
		printMeeting(tmp2);
	}
	else printMeeting(m);
	tabcnt -=1;
}

void checkcourseAttr(CourseAttrNode* c){
	
	if(c->thisNodeType==cAttrList){
	if(c->courseNodePtr->cAttrList.codecount == 0 || c->courseNodePtr->cAttrList.codecount >1 )
        multiple_attr_error("course", "code",c->courseNodePtr->cAttrList.codecount,yylloc.first_line);
	if(c->courseNodePtr->cAttrList.typecount == 0 || c->courseNodePtr->cAttrList.typecount >1 )
        multiple_attr_error("course", "type",c->courseNodePtr->cAttrList.typecount,yylloc.first_line);
	if(c->courseNodePtr->cAttrList.namecount == 0 || c->courseNodePtr->cAttrList.namecount >1 )
        multiple_attr_error("course", "name",c->courseNodePtr->cAttrList.namecount,yylloc.first_line);}

	else if(c->thisNodeType==cAttrname){
		multiple_attr_error("course", "type",0,yylloc.first_line);			
                 multiple_attr_error("course", "code",0,yylloc.first_line);
	}
	else if(c->thisNodeType==cAttrtype){
		multiple_attr_error("course", "name",0,yylloc.first_line);			
                 multiple_attr_error("course", "code",0,yylloc.first_line);
	}
	else if(c->thisNodeType==cAttrcode){
		multiple_attr_error("course", "name",0,yylloc.first_line);			
                 multiple_attr_error("course", "type",0,yylloc.first_line);
	}
	
	
}
void checkclassAttr(ClassAttrNode* c){
	if(c->thisNodeType == clAttrList){
	if(c->classNodePtr->clAttrList.sectioncount == 0 || c->classNodePtr->clAttrList.sectioncount >1 )
         multiple_attr_error("class", "section",c->classNodePtr->clAttrList.sectioncount,yylloc.first_line);
	if(c->classNodePtr->clAttrList.instructorcount == 0 || c->classNodePtr->clAttrList.instructorcount >1 )
         multiple_attr_error("class", "instructor",c->classNodePtr->clAttrList.instructorcount,yylloc.first_line);
	if(c->classNodePtr->clAttrList.crncount == 0 || c->classNodePtr->clAttrList.crncount >1 )
         multiple_attr_error("class", "crn",c->classNodePtr->clAttrList.crncount,yylloc.first_line);
	if(c->classNodePtr->clAttrList.capacitycount == 0 || c->classNodePtr->clAttrList.capacitycount >1 )
         multiple_attr_error("class", "capacity",c->classNodePtr->clAttrList.capacitycount,yylloc.first_line);
	}
	else if(c->thisNodeType==clAttrsection){
		 multiple_attr_error("class", "crn",0,yylloc.first_line);
		 multiple_attr_error("class", "instructor",0,yylloc.first_line);			
                 multiple_attr_error("class", "capacity",0,yylloc.first_line);
	}
	else if(c->thisNodeType==clAttrinstructor){
		 multiple_attr_error("class", "crn",0,yylloc.first_line);
		 multiple_attr_error("class", "section",0,yylloc.first_line);			
                 multiple_attr_error("class", "capacity",0,yylloc.first_line);
	}
	else if(c->thisNodeType==clAttrcrn){
		 multiple_attr_error("class", "section",0,yylloc.first_line);
		 multiple_attr_error("class", "instructor",0,yylloc.first_line);			
                 multiple_attr_error("class", "capacity",0,yylloc.first_line);
	}
	else if(c->thisNodeType==clAttrcapacity){
		 multiple_attr_error("class", "crn",0,yylloc.first_line);
		 multiple_attr_error("class", "instructor",0,yylloc.first_line);			
                 multiple_attr_error("class", "section",0,yylloc.first_line);
	}
	
	
}
void checkmeetingAttr(MeetingAttrNode* c){
	if(c->thisNodeType == mAttrList){
	if(c->meetingNodePtr->mAttrList.startcount == 0 || c->meetingNodePtr->mAttrList.startcount >1 )
         multiple_attr_error("meeting", "start",c->meetingNodePtr->mAttrList.startcount,yylloc.first_line);
	if(c->meetingNodePtr->mAttrList.daycount == 0 || c->meetingNodePtr->mAttrList.daycount >1 )
         multiple_attr_error("meeting", "day",c->meetingNodePtr->mAttrList.daycount,yylloc.first_line);
	if(c->meetingNodePtr->mAttrList.endcount == 0 || c->meetingNodePtr->mAttrList.endcount >1 )
         multiple_attr_error("meeting", "end",c->meetingNodePtr->mAttrList.endcount,yylloc.first_line);}
	else if(c->thisNodeType==mAttrday){
		multiple_attr_error("meeting", "start",0,yylloc.first_line);			
                 multiple_attr_error("meeting", "end",0,yylloc.first_line);
	}else if(c->thisNodeType==mAttrend){
		multiple_attr_error("meeting", "start",0,yylloc.first_line);			
                 multiple_attr_error("meeting", "day",0,yylloc.first_line);
	}else if(c->thisNodeType==mAttrstart){
		multiple_attr_error("meeting", "day",0,yylloc.first_line);			
                 multiple_attr_error("meeting", "end",0,yylloc.first_line);
	}
	
}
int main(){
	if(yyparse()){
		printf("ERROR\n");
		return 1;		
	}else if(foundError ==0){
		printTree();
		return 0;
	}	
}

