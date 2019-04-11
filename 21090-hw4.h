#ifndef __EX4_H
#define __EX4_H
#include <stdbool.h>
typedef enum { cAttrcode,cAttrtype, cAttrname, cAttrList, clAttrcapacity,clAttrcrn, clAttrsection, clAttrinstructor, clAttrList, mAttrstart,mAttrend, mAttrday, mAttrList, m_class, m_classList, m_course, m_courseList, m_meeting, m_meetingList, iAttrcrn, iAttrcode, iAttrList, m_item, m_itemList, items, courses} NodeType;

typedef struct courseAttrListNode {
int codecount;
int namecount;
int typecount;
struct CourseAttrNode *leftChild;
struct CourseAttrNode *rightChild;
} courseAttrListNode;

typedef struct m_meetingListNode {
NodeType thisNodeType;
struct MeetingNode *leftChild;
struct MeetingNode *rightChild;
} m_meetingListNode;

typedef struct m_meetingNode {
NodeType thisNodeType;
struct MeetingAttrNode *attrs;
} m_meetingNode;

typedef struct m_classListNode {
NodeType thisNodeType;
struct ClassNode *leftChild;
struct ClassNode *rightChild;
} m_classListNode;

typedef struct m_classNode {
NodeType thisNodeType;
struct ClassAttrNode *attrs;
struct MeetingNode *meetings;
} m_classNode;

typedef struct m_itemNode {
NodeType thisNodeType;
struct ItemAttrNode *attrs;
} m_itemNode;

typedef struct m_itemListNode {
NodeType thisNodeType;
struct ItemNode *leftChild;
struct ItemNode *rightChild;
} m_itemListNode;

typedef struct m_courseListNode {
NodeType thisNodeType;
struct CourseNode *leftChild;
struct CourseNode *rightChild;
} m_courseListNode;

typedef struct m_courseNode {
NodeType thisNodeType;
struct CourseAttrNode *attrs;
struct ClassNode *classes;
} m_courseNode;


typedef struct classAttrListNode {
int capacitycount;
int crncount;
int sectioncount;
int instructorcount;

struct ClassAttrNode *leftChild;
struct ClassAttrNode *rightChild;
} classAttrListNode;

typedef struct courseAttrcodeNode{
char *code;
}courseAttrcodeNode;

typedef struct courseAttrtypeNode{
char *type;
}courseAttrtypeNode;

typedef struct courseAttrnameNode{
char *name;
}courseAttrnameNode;

typedef struct itemAttrcodeNode{
char *code;
int lineno;
}itemAttrcodeNode;

typedef struct itemAttrcrnNode{
char *crn;
int lineno;
}itemAttrcrnNode;

typedef struct courseAttrcrnNode{
char *name;
}courseAttrcrnNode;

typedef struct classAttrcapacityNode{
char *capacity;
}classAttrcapacityNode;

typedef struct classAttrcrnNode{
char *crn;
}classAttrcrnNode;

typedef struct classAttrsectionNode{
char *section;
}classAttrsectionNode;

typedef struct classAttrinstructorNode{
char *instructor;
}classAttrinstructorNode;

typedef struct meetingAttrListNode {
int startcount;
int endcount;
int daycount;
struct MeetingAttrNode *leftChild;
struct MeetingAttrNode *rightChild;
} meetingAttrListNode;

typedef struct itemAttrListNode {
struct ItemAttrNode *leftChild;
struct ItemAttrNode *rightChild;
} itemAttrListNode;


typedef struct meetingAttrstartNode {
char* start;
} meetingAttrstartNode;

typedef struct meetingAttrendNode {
char* end;
} meetingAttrendNode;

typedef struct meetingAttrdayNode {
char* day;
} meetingAttrdayNode;

typedef union {
m_courseNode m_course;
m_courseListNode m_courseList;
} cNode;

typedef union {
m_classNode m_class;
m_classListNode m_classList;
} clNode;

typedef union {
m_meetingNode m_meeting;
m_meetingListNode m_meetingList;
} mNode;

typedef union {
m_itemNode m_item;
m_itemListNode m_itemList;
} iNode;

typedef union {
classAttrcapacityNode clAttrcapacity;
classAttrcrnNode clAttrcrn;
classAttrsectionNode clAttrsection;
classAttrinstructorNode clAttrinstructor;
classAttrListNode clAttrList;
} classAttrsNode;

typedef union {
courseAttrcodeNode cAttrcode;
courseAttrtypeNode cAttrtype;
courseAttrnameNode cAttrname;
courseAttrListNode cAttrList;
} courseAttrsNode;

typedef union {
itemAttrcodeNode iAttrcode;
itemAttrcrnNode iAttrcrn;
itemAttrListNode iAttrList;
} itemAttrsNode;


typedef union {
meetingAttrstartNode mAttrstart;
meetingAttrendNode mAttrend;
meetingAttrdayNode mAttrday;
meetingAttrListNode mAttrList;
} meetingAttrsNode;

typedef struct MeetingAttrNode {
NodeType thisNodeType;
meetingAttrsNode *meetingNodePtr;
} MeetingAttrNode;

typedef struct ClassAttrNode {
NodeType thisNodeType;
classAttrsNode *classNodePtr;
} ClassAttrNode;

typedef struct CourseAttrNode {
NodeType thisNodeType;
courseAttrsNode *courseNodePtr;
} CourseAttrNode;

typedef struct ItemAttrNode {
NodeType thisNodeType;
itemAttrsNode *itemNodePtr;
} ItemAttrNode;

typedef struct MeetingNode {
NodeType thisNodeType;
mNode *meetingNodePtr;
} MeetingNode;


typedef struct ClassNode {
NodeType thisNodeType;
clNode *classNodePtr;
} ClassNode;

typedef struct CourseNode {
NodeType thisNodeType;
cNode *courseNodePtr;
} CourseNode;

typedef struct ItemNode {
NodeType thisNodeType;
iNode *itemNodePtr;
} ItemNode;

typedef union {
ItemNode *items;
CourseNode *courses;
} ElementNode;

typedef struct TreeNode {
NodeType thisNodeType;
ElementNode *elementNodePtr;
} TreeNode;


#endif
