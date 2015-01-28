/*
 *   Copyright (c) 2014 Kulykov Oleh <nonamedemail@gmail.com>
 *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy
 *   of this software and associated documentation files (the "Software"), to deal
 *   in the Software without restriction, including without limitation the rights
 *   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *   copies of the Software, and to permit persons to whom the Software is
 *   furnished to do so, subject to the following conditions:
 *
 *   The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *   THE SOFTWARE.
 */


#include "../fayecpp.h"


namespace FayeCpp {
	
	VariantList & VariantList::operator+=(int v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(float v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(double v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(long long v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(unsigned long long v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(long double v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(bool v)
	{
		this->add(v);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const REString & s)
	{
		this->add(s);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const char * s)
	{
		this->add(s);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const wchar_t * s)
	{
		this->add(s);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const VariantMap & m)
	{
		this->add(m);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const VariantList & l)
	{
		this->add(l);
		return *this;
	}
	
	VariantList & VariantList::operator+=(const Variant & v)
	{
		this->add(v);
		return *this;
	}
	
    VariantList & VariantList::operator=(const VariantList & list)
	{
		this->clear();
		
		VariantList::Iterator i = list.iterator();
		while (i.next()) 
		{
			this->add(i.value());
		}
		
		return *this;
	}
	
	VariantList::VariantList(const VariantList & list)
	{
		*this = list;
	}
	
	VariantList::VariantList()
	{
		
	}
	
	VariantList::~VariantList()
	{
		
	}

}

