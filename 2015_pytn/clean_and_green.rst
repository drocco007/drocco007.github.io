.. |br| raw:: html

    <br/>


slide
-----

slide
-----

    “You wanted a banana but what you got was a gorilla holding the
    banana and the entire jungle.”

    —Joe Armstrong


Clean and Green
---------------

Pragmatic Architecture Patterns

| PyTennessee — February 8, 2015
| @drocco007


Why?
----


slide
-----

you build systems


slide
-----

build

*understandable*

systems


slide
-----

build

understandable, *testable*

systems


slide
-----

build

understandable, testable, *maintainable*

systems


slide
-----

build new or **transform existing** systems

such that they are

*understandable, testable, maintainable*


slide
-----

Why is this so challenging in practice?


slide
-----

We learned that it was sufficient to

**hide complexity**

behind reasonable, coherent interfaces


.. slide
.. -----

..     Testing raises our awareness of the external interface to the
..     software and ensures our software is *conveniently callable*

..     — Uncle Bob Martin


slide
-----

But is convenient callability enough?


slide
-----

Example: Let's build a dashboard populated with data from a Web API


slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')
        response = requests.get(url)  # I/O

        open_requests = []
        for pr in response.json()['values']:  # I/O
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


slide
-----

The external interface is convenient

.. fake function to make the doctest pass... sigh.
..
    >>> def get_open_pull_requests(*args):
    ...     return [{
    ...         'author': 'pauline',
    ...         'title': 'Never Said I Was an Angel',
    ...     }]


.. code-block:: python

    >>> get_open_pull_requests('drocco', 'some_repo')  # doctest: +NORMALIZE_WHITESPACE
    [{'title': 'Never Said I Was an Angel',
      'author': 'pauline'}]

|
| (and since we're in Nashville,
| cue obscure musical reference ;)


slide
-----

but


slide
-----

Inside the encapsulation is a coupled procedure


slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')
        response = requests.get(url)  # I/O

        open_requests = []
        for pr in response.json()['values']:  # I/O
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        ··· = '···················································' \
            .······(·····, ··········, '············')
        response = requests.get(url)  # I/O

        ············· = []
        ··· ·· ·· response.json()['values']:  # I/O
            ·············.······({
                '······': ··['······']['········'],
                '·····': ··['·····'],
            })

        ······ ·············


slide
-----

*Why does it matter?*


slide
-----

It matters because you want to build

*understandable, testable, maintainable*

systems


slide
-----

The issue is **complexity**


slide
-----

*Simple* is better than **complex**


slide
-----

*Coupled procedures* are **inherently complex**


slide
-----

*Coupled procedures* are hard to

**understand, test, maintain**


.. slide
.. -----

.. Now imagine this as a method


.. slide
.. -----

.. Methods **implicitly depend** on

.. mutable instance state


.. slide
.. -----

.. Methods are therefore

.. **coupled** to that state


.. slide
.. -----

.. and therefore to each other


.. slide
.. -----

.. “Now you have two problems…”


slide
-----

What are we trying to test?


slide
-----

well, …


slide
-----

What does *our system* care about?


.. slide
.. -----

.. .. code-block:: python

..     def get_open_pull_requests(owner, repository):
..         url = 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
..             .format(owner, repository, 'pullrequests')
..         response = requests.get(url)  # I/O

..         open_requests = []
..         for pr in response.json()['values']:  # I/O
..             open_requests.append({
..                 'author': pr['author']['username'],
..                 'title': pr['title'],
..             })

..         return open_requests


slide
-----

Given a correct response from the API,

return the appropriate bits from the payload.


slide
-----

We need to test *our logic* in

``get_open_pull_requests()``

with a variety of responses


slide
-----

Higher-level question:

    In general, how can we build testable systems
    that have nontrivial, stateful dependencies?


slide
-----

disk, Web, database, …


slide
-----

Common approach: fake it


slide
-----

Fake it: build API-compatible replacements
for your dependencies with test fixture support


slide
-----

==============================  =================
Mock                            (general)
WebTest                         (WSGI)
responses, httpretty, …         (HTTP client)
SQLite, transaction wrappers    (DB)
mocks, stubs, doubles, …        (domain)
==============================  =================


slide
-----

Faking it has


slide
-----

problems


slide
-----

Test and production calls are asymmetric


slide
-----

Production:

.. code-block:: python

    open_prs = get_open_pull_requests('drocco', 'repo')


Test:

.. code-block:: python

    def test_get_open_pr():
        fake = FakeRequests(data={…})

        with mock.patch('requests.get', fake.get):
            open_prs = get_open_pull_requests('drocco', 'repo')


slide
-----

| Tricky, brittle, awkward mechanics
| (``patch()``, dependency injection)


slide
-----

Your mock isn't the real library


slide
-----

But more importantly,


slide
-----

Faking it doen't put

*design pressure*

on the **complexity** of your system


slide
-----

    The real benefit of **isolated** tests is that those tests put
    *tremendous pressure* on our designs

    — J B Rainsberger


slide
-----

    Testing forces us to *decouple* the software, since highly-coupled
    software is **more difficult to test**

    — Uncle Bob Martin


slide
-----




.. slide
.. -----

.. | coupled: *combined, connected, joined*
.. |
.. | procedure: subroutine that relies on *mutable state*


.. slide
.. -----

.. *Coupled procedures* are **complex** because

.. *results*

.. depend on **collaborations** and **mutable state**


slide
-----

Is there an alternative?


slide
-----

Fake it: build API-compatible replacements
for your dependencies with test fixture support

|
|
|


slide
-----

Fake it: build API-compatible replacements
for your dependencies with test fixture support

Clean Architecture: separate *policies* from
*mechanisms* and pass **simple data structures**
between the two


How?
----


This talk
---------


slide
-----

*How do I recognize hidden complexity?*


slide
-----

*What patterns can I apply to remedy it?*


slide
-----

*How do I build systems I can change confidently?*


slide
-----

*How do I organize larger systems?*


slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')
        response = requests.get(url)  # I/O

        open_requests = []
        for pr in response.json()['values']:  # I/O
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


Pragmatic Pattern 1: Promote I/O
--------------------------------


slide
-----

Promote I/O:

decouple by separating

*domain policies* from **I/O**


slide
-----

I/O lives in thin, “procedural glue” layer



slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')
        response = requests.get(url)  # I/O

        open_requests = []
        for pr in response.json()['values']:  # I/O
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


slide
-----

becomes


slide
-----

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = build_url(owner, repository)
        response = requests.get(url)  # I/O
        data = response.json()  # I/O
        return extract_pull_requests(data)


..

    .. def build_url(owner, repository):
    ..     return 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
    ..         .format(owner, repository, 'pullrequests')

    .. def extract_pull_requests(data):
    ..     open_requests = []
    ..     for pr in data['values']:
    ..         open_requests.append({
    ..             'author': pr['author']['username'],
    ..             'title': pr['title'],
    ..         })

    ..     return open_requests


slide
-----

Highly abstracted, readable manager procedure

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        url = build_url(owner, repository)
        response = requests.get(url)  # I/O
        data = response.json()  # I/O
        return extract_pull_requests(data)


slide
-----

Instead of **encapsulating** I/O, we *promote* it

.. code-block:: python

    def get_open_pull_requests(owner, repository):
        ··· = ·········(······ ··········)
        response = requests.get(url)  # I/O
        data = response.json()  # I/O
        ······ ·····················(····)


slide
-----

Eliminating the I/O dependency in our logic

.. code-block:: python

    def build_url(owner, repository):
        return 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')

    def extract_pull_requests(data):
        open_requests = []
        for pr in data['values']:
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


slide
-----

Policies are clearly separated from mechanisms

.. code-block:: python

    def build_url(owner, repository):
        return 'https://api.bitbucket.org/2.0/repositories/{}/{}/{}' \
            .format(owner, repository, 'pullrequests')

    def extract_pull_requests(data):
        open_requests = []
        for pr in data['values']:
            open_requests.append({
                'author': pr['author']['username'],
                'title': pr['title'],
            })

        return open_requests


slide
-----

Policies are easily testable using simple data

.. code-block:: python

    def test_build_url():
        expected = 'https://api.bitbucket.org/2.0/repositories' \
            '/drocco/repo/pullrequests'

        assert expected == build_url('drocco', 'repo')

    def test_extract_with_no_pull_requests():
        assert not extract_pull_requests({'values': []})

    def test_extract_pull_requests():
        pr_data = {'values': [{'author': {'username': 'amber'},
                               'title': 'Add git mastery lessons'}]}

        assert 'amber' == extract_pull_requests(pr_data)['author']


slide
-----

By improving the *testability* of this code,

we have also improved its


slide
-----

design


slide
-----

Another problem

    | Given a root path, return a *list of sets*
    | each set containing *all paths*
    | that have **identical contents**


slide
-----

Here's the idea:

.. code-block:: python

    In [1]: locate_paths_with_same_content('~/photos')
    Out[1]: [{'a.jpg'},
             {'b.jpg', 'backup/copy_of_b.jpg'},
             …]


slide
-----

My first attempt

.. code-block:: python

    def locate_paths_with_same_content(root):
        file_map = defaultdict(set)

        for path in locate_files(root):  # I/O
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

| ``locate_files()`` is a
| *thin wrapper* around ``os.walk()``

.. code-block:: python

    def locate_paths_with_same_content(root):
        ········ = ···········(···)

        for path in locate_files(root):  # I/O
            ········· = ·············(····)  # I/O
            ·······················(····)

        ······ ···············()


slide
-----

| ``hash_contents`` computes, say,
| the SHA256 of a file's contents

.. code-block:: python

    def locate_paths_with_same_content(root):
        ········ = ···········(···)

        for ···· ·· ············(····):  # I/O
            file_hash = hash_contents(path)  # I/O
            ·······················(····)

        ······ ···············()


Q:
--


Q:
--

How would you test this?


slide
-----

.. code-block:: python

    def locate_paths_with_same_content(root):
        file_map = defaultdict(set)

        for path in locate_files(root):  # I/O
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

``locate_files()`` and ``hash_contents()``

are *embedded* within the procedure's logic



slide
-----

As we have seen, coupling is not an abstract, theoretical problem


slide
-----

``locate_files()`` and ``hash_contents()``

depend on the state of the disk


slide
-----

which means…


slide
-----

*Your tests*

depend on the state of the disk


slide
-----

(or on the energy you're willing to expend simulating that state)


slide
-----

.. code-block:: python

    def locate_paths_with_same_content(root):
        file_map = defaultdict(set)

        for path in locate_files(root):  # I/O
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


.. slide
.. -----

.. .. code-block:: python

..     def locate_paths_with_same_content(root):
..         file_map = defaultdict(set)

..         for path in locate_files(root):  # I/O
..             file_hash = hash_contents(path)  # I/O
..             file_map[file_hash].add(path)

..         return file_map.values()


slide
-----

A *(very short)* walk down the path of destruction


slide
-----

| “Well, we could create a
| *temporary file tree* with
| **known values**, …”



slide
-----

.. code-block:: python

    def test_simple_case():
        # generate a bunch of files with known values, yielding
        # the root of the temporary tree as the context variable
        with horrible_tmp_tree_context_1() as temproot:
            assert magical_expected_value == locate_paths_with_same_content(temproot)


slide
-----

*Simple* is better than **complex**


slide
-----

This isn't *simple*…


slide
-----

You'll need context managers for

*various classes* of test cases


slide
-----

Realistically,

*how many test cases*

will you have the **energy** to write this way?


slide
-----

It'll be slow

slow → inefficient


slide
-----

Stepping back


slide
-----

*What do we* **actually care about** *here?*


slide
-----

    | Given a root path, return a *list of sets*
    | each set containing *all paths*
    | that have **identical contents**


slide
-----

| *assume* ``os.walk()`` works…
| *assume* ``open(…).read()`` works…
| *assume* ``sha256(…).digest()`` works…


slide
-----

in other words,

if we subtract these assumptions

from our subroutine


slide
-----

.. code-block:: python

    def locate_paths_with_same_content(root):
        file_map = defaultdict(set)

        for path in ×××:
            file_hash = ×××
            file_map[file_hash].add(path)

        return file_map.values()



slide
-----

We care that

* two **strings** (paths)
* end up in the same bucket
* if they're annotated with the same **value** (content hash)


slide
-----

For our testing purposes,

*coupling* is a **distraction**


.. but
.. ---


.. How can we avoid it?
.. --------------------


.. slide
.. -----

.. | “No go on the temp trees.
.. | Let's try *mocking/DI*!”


.. slide
.. -----

.. .. code-block:: python

..     def locate_paths_with_same_content(
..             root,
..             locate_files=locate_files,
..             hash_contents=hash_contents):

..         file_map = defaultdict(set)

..         for path in locate_files(root):  # I/O
..             file_hash = hash_contents(path)  # I/O
..             file_map[file_hash].add(path)

..         return file_map.values()



.. slide
.. -----

..     Test Isolation Is About Avoiding Mocks

..     — Gary Bernhardt


slide
-----

First, apply Pattern 1: **Promote I/O**


slide
-----

.. code-block:: python

    def locate_paths_with_same_content(root):
        # …

↓

.. code-block:: python

    def locate_paths_with_same_content(root):
        paths = locate_files(root)  # I/O
        return paths_with_same_hash(paths)

    def paths_with_same_hash(paths):
        file_map = defaultdict(set)

        for path in paths:
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

Already an improvement, but…


How do we get rid of ``hash_contents()``?
-----------------------------------------


slide
-----

.. code-block:: python

    def paths_with_same_hash(paths):
        file_map = defaultdict(set)

        for path in paths:
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


Pragmatic Pattern 2: Data and Transforms
----------------------------------------


slide
-----

| *Data* and *transforms* are easier
| to understand and maintain
| than **coupled procedures**


slide
-----

.. code-block:: python

    def paths_with_same_hash(paths):
        file_map = defaultdict(set)

        for path in paths:
            file_hash = hash_contents(path)  # I/O
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

policy
    | paths with the same hash
    | share the same bucket
    |

mechanism
    .. code-block:: python

        for path in paths:
            file_hash = hash_contents(path)  # I/O


slide
-----

**Data and Transforms**

| recast logic to operate on
| an *annotated transform*
| of the data


slide
-----

.. code-block:: python

    def locate_paths_with_same_content(root):
        paths = locate_files(root)  # I/O
        annotated_paths = hash_paths(paths)  # I/O
        return paths_with_same_hash(annotated_paths)

    def hash_paths(paths):
        return [(hash_contents(path), path) for path in paths]  # I/O

    def paths_with_same_hash(annotated_paths):
        file_map = defaultdict(set)

        for file_hash, path in annotated_paths:
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

| Transform produces *simple data values*
| for policy consumption


.. code-block:: python

    def hash_paths(paths):
        return [(hash_contents(path), path) for path in paths]  # I/O


slide
-----

| Policy is a *pure function*
| that operates on **simple data values**

.. code-block:: python

    def paths_with_same_hash(annotated_paths):
        file_map = defaultdict(set)

        for file_hash, path in annotated_paths:
            file_map[file_hash].add(path)

        return file_map.values()


slide
-----

Policy is easily tested with simple data

.. code-block:: python

    def test_simple_difference():
        annotated_paths = [('0xdead', 'a.jpg'), ('0xbeef', 'b.jpg')]

        assert 2 == len(paths_with_same_hash(annotated_paths))


    def test_simple_match():
        annotated_paths = [('0000', 'b.jpg'), ('0000', 'also_b.jpg')]

        assert 1 == len(paths_with_same_hash(annotated_paths))



slide
-----

From my domain: has a candidate reached the application limit for an exam?


slide
-----

.. code-block:: python

    def get_available_sections(user, exam_type, …):
        # …
        fail_dates = []
        for app in user.applications:
            if not app.withdrawn:
                # …
                if exam_type == app.exam_type:
                    fail_dates.append(app.exam_date)

        def handle_application_limit_reached():
            limit_msg = format_limit_message(exam_type)
            raise ApplicationLimitReachedException(limit_msg)

        if exam_type.limit_applications:
            if len(fail_dates) >= exam_type.application_limit:
                if exam_type.application_limit_interval == 'ever':
                    handle_application_limit_reached()
                else:
                    fail_dates.sort()
                    limit_date = fail_dates[-exam_type.application_limit] + …

                    if third_party and limit_date > now:
                        handle_application_limit_reached()


slide
-----

Don't try to read it,

just scan for overall structure


slide
-----

.. code-block:: python

    def get_available_sections(user, exam_type, …):
        # …
        fail_dates = []
        for app in user.applications:
            if not app.withdrawn:
                # …
                if exam_type == app.exam_type:
                    fail_dates.append(app.exam_date)

        def handle_application_limit_reached():
            limit_msg = format_limit_message(exam_type)
            raise ApplicationLimitReachedException(limit_msg)

        if exam_type.limit_applications:
            if len(fail_dates) >= exam_type.application_limit:
                if exam_type.application_limit_interval == 'ever':
                    handle_application_limit_reached()
                else:
                    fail_dates.sort()
                    limit_date = fail_dates[-exam_type.application_limit] + …

                    if third_party and limit_date > now:
                        handle_application_limit_reached()


slide
-----

Danger signs

* enormous method (this excerpt is < ¼)
* deep nesting
* this bit has nothing to do with exam sections…

.. code-block:: python

    def get_available_sections(user, exam_type, …):


slide
-----

Let's tackle ``fail_dates``, applying multiple Pattern 2 transforms…


Pragmatic Pattern 3: Pipeline
-----------------------------


slide
-----

Handling of ``fail_dates`` is obscure, spread out


slide
-----

.. code-block:: python

    def get_available_sections(user, exam_type, …):

        fail_dates = []
        for app in user.applications:
            if not app.withdrawn:
                if exam_type == app.exam_type:
                    fail_dates.append(app.exam_date)





        if …:
            if len(fail_dates) >= exam_type.application_limit:
                if …:
                else:
                    fail_dates.sort()
                    limit_date = fail_dates[-exam_type.application_limit] + …


slide
-----

Input data: candidate applications

.. code-block:: python

    def get_available_sections(user, exam_type, …):


        for app in user.applications:


slide
-----

Four transforms


slide
-----

Filter out withdrawn applications:

.. code-block:: python

    def get_available_sections(user, exam_type, …):

        for app in user.applications:
            if not app.withdrawn:

                    fail_dates.append(app.exam_date)


slide
-----

Filter out applications for other exams:

.. code-block:: python

    def get_available_sections(user, exam_type, …):

        for app in user.applications:

                if exam_type == app.exam_type:
                    fail_dates.append(app.exam_date)


slide
-----

Extract the exam date

.. code-block:: python

    def get_available_sections(user, exam_type, …):




                    fail_dates.append(app.exam_date)

–  and –

Sort the result


slide
-----

Obscure purpose,

Cryptic implementation


slide
-----

Pipeline: apply a *series* of transforms to achieve the result you need


slide
-----

Filter out withdrawn applications:

.. code-block:: python

    def not_withdrawn(applications):
        return [application for application in applications
                if application.status_name != 'withdrawn']


slide
-----

Filter applications to the correct type:

.. code-block:: python

    def of_type(applications, exam_type):
        return [application for application in applications
                if application.exam_type == exam_type]


slide
-----

Connect the pipeline

.. code-block:: python

    prior_apps = not_withdrawn(of_type(user.applications, exam_type))
    fail_dates = sorted(app.exam_date for app in prior_apps)


slide
-----

Pipeline allows a **complex transform**

to be expressed as a

*series of simple transforms*


slide
-----

.. code-block:: python

    prior_apps = not_withdrawn(of_type(user.applications, exam_type))
    fail_dates = sorted(app.exam_date for app in prior_apps)


slide
-----

These transforms are *easily tested*

and *convenient to reuse*


slide
-----

.. code-block:: python

    prior_apps = not_withdrawn(of_type(user.applications, exam_type))
    fail_dates = sorted(app.exam_date for app in prior_apps)


slide
-----

So far


slide
-----

build new or **transform existing** systems

such that they are

*understandable, testable, maintainable*


slide
-----

A common approach uses **coupled procedures**

with *fake implementations* for testing


slide
-----

instead…


slide
-----

Build systems around

**functional transforms**

of *simple values* and *data structures*


Objection!
----------


slide
-----

No one argues the

*high-level expressivity* & *convenient testability*

of **pure functions**



slide
-----

So what's the problem?


slide
-----

.. code-block:: python

    >>> objections = {'a'} | {'b'}


slide
-----

“That's a fine academic toy,

but it can't build **real** systems.”


slide
-----

(“real” generally being a euphemism

for “HTML-producing” ;)


slide
-----

“We can't afford to

**rewrite**

our *whole system*!”


slide
-----

These concerns are understandable,


slide
-----

but not *true*


Claim
-----


slide
-----

You don't *need* a full rewrite


slide
-----

(and you definitely **should not** attempt one)


slide
-----

You *can* build real systems this way


slide
-----

*Simple* is better than **complex**


slide
-----

Build systems around

**functional transforms**

of *simple values* and *data structures*


How?
----

slide
-----

Apply the Clean Architecture


slide
-----

.. image:: static/CleanArchitecture.jpg


slide
-----

| “In general, the *further in* you go,
| the **higher level** the software becomes.
| The *outer circles* are mechanisms.
| The *inner circles* are policies.”


slide
-----

| “The important thing is
| that *isolated, simple* data structures
| are passed across the boundaries.”


This is the key!
----------------


slide
-----

| “The important thing is
| that *isolated, simple* data structures
| are passed across the boundaries.”


slide
-----

| “When any of the *external parts*
| of the system become **obsolete**, like
| the database, or the web framework,
| you can **replace** those obsolete
| elements with a minimum of fuss.”

— Uncle Bob Martin


Pragmatic Architecture Patterns
-------------------------------

Tools for applying the Clean Architecture to *existing systems* and new work


Pragmatic Architecture Patterns
-------------------------------

1. Promote I/O
2. Data and Transforms
3. Pipeline


slide
-----

How do you organize a system this way?


slide
-----

Another real example


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        if agreement.start_date <= date.today():
            return {'success': False, 'msg': 'Error: already active'}
        if EndUserAgreement.query.count() == 1:
            return {'success': False, 'msg': 'Error: only agreement'}

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()
        return {'success': True}


slide
-----

Fetch the agreement to delete from the ORM

.. code-block:: python

    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        #                                                              …


slide
-----

Check that it is not yet active

.. code-block:: python

    def delete(self, id):
        #                                                              …

        if agreement.start_date <= date.today():
            return {'success': False, 'msg': 'Error: already active'}

        #                                                              …

(and format a message back if it is)


slide
-----

and that it is not the only agreement

.. code-block:: python

    def delete(self, id):
        #                                                              …

        if EndUserAgreement.query.count() == 1:
            return {'success': False, 'msg': 'Error: only agreement'}

        #                                                              …


slide
-----

| Adjust either the previous or next
| agreement to cover any gap

.. code-block:: python

    def delete(self, id):
        #                                                              …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

slide
-----

Engage

.. code-block:: python

    def delete(self, id):
        #                                                              …

        agreement.delete()
        return {'success': True}


slide
-----

Again…


slide
-----

How would you test this?


slide
-----

How would you test

* 5–6 ORM calls
* ≥ 3 business rules
* ≥ 5 axes of responsibility


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        if agreement.start_date <= date.today():
            return {'success': False, 'msg': 'Error: already active'}
        if EndUserAgreement.query.count() == 1:
            return {'success': False, 'msg': 'Error: only agreement'}

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()
        return {'success': True}


Q:
--

How would you implement

**custom rules**

if a client asked?


Counterpoint
------------

How could we possibly convert

**delete()**

to a pure functional form?


slide
-----

(for Pete's sake, dan, even the *name* has state mutation in it!)


Pragmatic Pattern 4: FauxO
--------------------------

Functional core, imperative shell


slide
-----

Imperative shell:

**procedural “glue”**  that offers

an *OO interface* & *manages dependencies*


slide
-----

Functional core:

implements **all** the *decisions*


Key rule
--------

Never mix *decisions* and **dependencies**


slide
-----

*logic* goes only in the **functional core**


slide
-----

*dependencies* go only in the **imperative shell**


slide
-----

Pass *simple data* between the two


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        if agreement.start_date <= date.today():
            return {'success': False, 'msg': 'Error: already active'}
        if EndUserAgreement.query.count() == 1:
            return {'success': False, 'msg': 'Error: only agreement'}

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()
        return {'success': True}



slide
-----

Step 0: EAFP


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    @error_handler(handle_REST_error)
    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        if agreement.start_date <= date.today():
            raise ValueError('Already active')
        if EndUserAgreement.query.count() == 1:
            raise ValueError('Only agreement')

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()


slide
-----

Step 1: pull out eveything that isn't dispatch


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    @error_handler(handle_REST_error)
    def delete(self, id):
        agreements.delete(id)


slide
-----

Our HTTP endpoint now does its

*one job*


slide
-----

call routing


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    @error_handler(handle_REST_error)
    def delete(self, id):
        agreements.delete(id)


(error handler left as an exercise ;)


slide
-----

We've reduced its **responsibility surface** four fold


slide
-----

It no longer has to change with

| the Agreement model
| the persistence subsystem
| the delete & gap adjustment rules
| the error reporting requirements


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    @error_handler(handle_REST_error)
    def delete(self, id):
        agreements.delete(id)


slide
-----

``agreements`` is a *manager* object in the imperative shell


slide
-----

``agreements`` gathers all the dependencies: stateful objects, system settings, required libraries


slide
-----

What does it look like?


Step 2: ``assert_removable()``
------------------------------

.. code-block:: python

    # agreements.py                                  (imperative shell)

    def delete(assignment_id):
        agreement = EndUserAgreement.get(id)
        all_agreements = EndUserAgreement.query

        assert_removable(agreement, all_agreements)

        # date adjustments temporariliy elided…

        agreement.delete()


slide
-----

Notice the divison of labor


slide
-----

``agreements.delete()``

| gathers the necessary data
| and performs the mutation


slide
-----

whereas


slide
-----

``assert_removable()``

| is logic that *decides* if the agreement
| can be deleted


slide
-----

FauxO Litmus test

| ``assert_removable()`` should work on
| a plain, non-ORM object


slide
-----

.. code-block:: python

    >>> from collections import namedtuple
    >>> Agreement = namedtuple('Agreement', 'start_date end_date')


slide
-----

.. code-block:: python

    # agreements_core.py                               (functional core)

    >>> def assert_removable(agreement, all_agreements):
    ...     assert agreement and agreement in all_agreements, \
    ...         'Invalid agreement'
    ...     assert agreement.start_date > date.today(), \
    ...         'Agreement already active'
    ...     assert len(all_agreements) > 1, \
    ...         'Cannot remove only agreement'


slide
-----

.. code-block:: python

    >>> from datetime import date, timedelta
    >>> tomorrow = date.today() + timedelta(1)
    >>> only_agreement = Agreement(tomorrow, None)
    >>> assert_removable(only_agreement, [only_agreement])
    Traceback (most recent call last):
        ...
    AssertionError: Cannot remove only agreement



slide
-----

.. code-block:: python

    >>> really_planning_ahead = date(3025, 1, 1)
    >>> current_agreement = Agreement(date.today(), really_planning_ahead)
    >>> next_agreement = Agreement(really_planning_ahead, None)
    >>> assert_removable(next_agreement, [current_agreement, next_agreement])

|

.. code-block:: python

    >>> assert_removable(current_agreement, [current_agreement, next_agreement])
    Traceback (most recent call last):
        ...
    AssertionError: Agreement already active


slide
-----

Next: date adjustments

.. code-block:: python

    def delete(assignment_id):
        agreement = EndUserAgreement.get(id)
        all_agreements = EndUserAgreement.query

        assert_removable(agreement, all_agreements)

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()


slide
-----

Challenge: disentangle the mutation from the rules


slide
-----

Rules

* what should be updated
* how it should be updated


Pragmatic Pattern 5: Delegated value
------------------------------------

Shell assigns a value computed by the core


slide
-----

.. code-block:: python

    # agreements.py (step 4)                          (imperative shell)

    def delete(assignment_id):
        agreement = EndUserAgreement.get(id)
        all_agreements = EndUserAgreement.query

        assert_removable(agreement, all_agreements)

        adjust_dates_for_delete(agreement)
        agreement.delete()


slide
-----

.. code-block:: python

    # agreements.py (step 4)                          (imperative shell)

    def adjust_dates_for_delete(agreement):
        previous = self.get_previous(agreement.start_date,
                                     agreement.id)
        next = self.get_next(agreement.start_date, id)

        target_agreement, updated_dates = \
            get_agreement_update(previous, agreement, next)
        target_agreement.update(updated_dates)


slide
-----

.. code-block:: python

    # agreements_core.py (step 4)                      (functional core)

    def get_agreement_update(previous, agreement, next)
        if previous_agreement:
            return previous_agreement, {'end_date':  agreement.end_date}
        else:
            return next_agreement, {'start_date':  agreement.start_date}


slide
-----

The core implements the rules

* which agreements need to be updated
* what the new dates should be


slide
-----

Stepping back


slide
-----

We started here


slide
-----

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    def delete(self, id):
        agreement = EndUserAgreement.get(id)

        if agreement.start_date <= date.today():
            return {'success': False, 'msg': 'Error: already active'}
        if EndUserAgreement.query.count() == 1:
            return {'success': False, 'msg': 'Error: only agreement'}

        # In order to ensure there are no gaps in agreements, …
        previous_agreement = self.get_previous(agreement.start_date, id)
        if previous_agreement:
            previous_agreement.end_date = agreement.end_date
        elif agreement.end_date:
            # If the deleted agreement was the first one, then we find…
            next_agreement = self.get_next(agreement.start_date, id)
            if next_agreement:
                next_agreement.start_date = agreement.start_date

        agreement.delete()
        return {'success': True}


slide
-----

mixed responsibilities

unclear rules

monolithic expression of intent


slide
-----

Practically untestable


slide
-----

Our functional core

.. code-block:: python


    def assert_removable(agreement, all_agreements):
        assert agreement and agreement in all_agreements, \
            'Invalid agreement'
        assert agreement.start_date > date.today(), \
            'Agreement already active'
        assert len(all_agreements) > 1, \
            'Cannot remove only agreement'

    def get_agreement_update(previous, agreement, next)
        if previous_agreement:
            return previous_agreement, {'end_date':  agreement.end_date}
        else:
            return next_agreement, {'start_date':  agreement.start_date}




slide
-----

| Eminently readable
| because each function remains at a
| *single level of abstraction*


slide
-----

.. code-block:: python


    def assert_removable(agreement, all_agreements):
        assert agreement and agreement in all_agreements, \
            'Invalid agreement'
        assert agreement.start_date > date.today(), \
            'Agreement already active'
        assert len(all_agreements) > 1, \
            'Cannot remove only agreement'

    def get_agreement_update(previous, agreement, next)
        if previous_agreement:
            return previous_agreement, {'end_date':  agreement.end_date}
        else:
            return next_agreement, {'start_date':  agreement.start_date}


slide
-----

Easily testable using *simple data structures*


slide
-----

* no special setup
* test calls are symmetric with production calls


slide
-----

Clear assignment of responsibilities

* Core → logic
* Shell → dependencies
* Endpoint → dispatch


slide
-----

FauxO interface provides a

*familiar façade*

to the rest of the system


slide
-----

Our HTTP endpoint

.. code-block:: python

    @expose()
    @identity.require(identity.has_permission('agreement_delete'))
    @error_handler(handle_REST_error)
    def delete(self, id):
        agreements.delete(id)


slide
-----

Our imperative shell

.. code-block:: python

    def delete(assignment_id):
        agreement = EndUserAgreement.get(id)
        all_agreements = EndUserAgreement.query

        assert_removable(agreement, all_agreements)

        adjust_dates_for_delete(agreement)
        agreement.delete()


slide
-----

Imperative shell (cont.)


.. code-block:: python

    def adjust_dates_for_delete(agreement):
        previous = self.get_previous(agreement.start_date,
                                     agreement.id)
        next = self.get_next(agreement.start_date, id)

        target_agreement, updated_dates = \
            get_agreement_update(previous, agreement, next)
        target_agreement.update(updated_dates)


slide
-----

Last examples from a

*real system*

that really serves

*real HTML*!


slide
-----

slide
-----

Thoughts for systems


slide
-----

Connect shells to each other

.. image:: shells.png


slide
-----

Or to existing legacy subsystems

.. image:: legacy.png


slide
-----

Pluggable components


slide
-----


slide
-----

T.S. Eliot


slide
-----

    Immature poets imitate;


slide
-----

    Immature poets imitate;

    mature poets *steal*

    — T.S. Eliot


slide
-----

Special thanks to

Brandon Rhodes the Great

from whom I've stolen many ideas over the years


slide
-----

Thank you!


slide
-----

♥

@drocco007

.. raw:: html

    <!-- single quote: ’
    double quotes: x“”x
    em-dash: —
    vertical ellipsis: ⋮
    arrows: ←, ↑, →, ↓, ↔, ↕, ↖, ↗, ↘, ↙ -->
    <script>
        window.slide_transition_time = 200;
    </script>
    <script src="static/jquery-1.6.2.min.js"></script>
    <script src="static/jquery.url.min.js"></script>
    <script src="static/slides2.js"></script>
