#include "21090-hw4.h"
	#include <string.h>
	#include <stdlib.h> 
        #include <stdio.h>
#define  MAX_ARR_SIZE 80
#define  NUM_STRING 80
char codelist [NUM_STRING][MAX_ARR_SIZE];
int crnlist [MAX_ARR_SIZE];


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
		ret->courseNodePtr->cAttrList.namecount += 1;
		else
		ret->courseNodePtr->cAttrList.codecount  = 1;
       }
	else if(right->thisNodeType == cAttrcode)
	{ ret->courseNodePtr->cAttrList.codecount  = 1;
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

ItemAttrNode * mkitemAttrcrn (int crn,int lineno) {
        
	ItemAttrNode * ret	= (ItemAttrNode *)malloc (sizeof(ItemAttrNode));
        ret->thisNodeType = iAttrcrn;
	ret->itemNodePtr = (itemAttrsNode *)malloc (sizeof(itemAttrsNode));
	char *tmp=malloc(32);
        sprintf(tmp, "%d", crn);
	ret->itemNodePtr->iAttrcrn.crn= tmp;
	ret->itemNodePtr->iAttrcrn.lineno = lineno;
	return (ret);
}
ItemAttrNode * mkitemAttrcode (char *code,int lineno) {
        
	ItemAttrNode * ret	= (ItemAttrNode *)malloc (sizeof(ItemAttrNode));
        ret->thisNodeType = iAttrcode;
	ret->itemNodePtr = (itemAttrsNode *)malloc (sizeof(itemAttrsNode));
	ret->itemNodePtr->iAttrcode.code = code;
	ret->itemNodePtr->iAttrcode.lineno = lineno;
	
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
