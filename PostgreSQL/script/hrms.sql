-- pg_dump -U postgres -W -p 5432 hrms > hrms.sql
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: helloworld(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.helloworld()
    LANGUAGE plpgsql
    AS $$ 
begin
	raise notice 'helloworld';
end; 
$$;


ALTER PROCEDURE public.helloworld() OWNER TO postgres;

--
-- Name: insert_project_count_sp(integer, character varying, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_project_count_sp(IN id integer, IN pname character varying, IN pdate date)
    LANGUAGE plpgsql
    AS $$ 
begin
	insert into project values(id,pname,pdate);
end; 
$$;


ALTER PROCEDURE public.insert_project_count_sp(IN id integer, IN pname character varying, IN pdate date) OWNER TO postgres;

--
-- Name: insert_project_count_sp(integer, character varying, date, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_project_count_sp(IN id integer, IN pname character varying, IN pdate date, INOUT rcount integer)
    LANGUAGE plpgsql
    AS $$ 
begin
	insert into project values(id,pname,pdate);
	
	select count(*) into rcount from manager;
end; 
$$;


ALTER PROCEDURE public.insert_project_count_sp(IN id integer, IN pname character varying, IN pdate date, INOUT rcount integer) OWNER TO postgres;

--
-- Name: insert_salary_sp(double precision, integer, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_salary_sp(IN inc_salary double precision, IN local_id integer, INOUT is_success boolean)
    LANGUAGE plpgsql
    AS $$ 
declare
	salary_prev float := 0.0;
	salary_after float := 0.0;
begin
	--retrieve prev -> update -> add inc -> set prev to after
	select salary into salary_prev from manager where id = local_id;
	update manager
	set salary = salary + inc_salary where id = local_id;
	select salary into salary_after from manager where id = local_id;
--conditional para sa java, add inout param
	if salary_prev < salary_after
			then is_success := true;
	else is_success := false;
	end if;
	--	raise notice 'Total new salary %', total;

end; 
$$;


ALTER PROCEDURE public.insert_salary_sp(IN inc_salary double precision, IN local_id integer, INOUT is_success boolean) OWNER TO postgres;

--
-- Name: show_projects_join_count_sp(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.show_projects_join_count_sp()
    LANGUAGE plpgsql
    AS $$ 
declare
	proj_count integer := 0;
	rec record;
begin
	for rec in select * from project natural join project_members
		loop
			raise notice '% % %', rec.projid, rec.projname, rec.projdate;
	end loop;
	select count(*) into proj_count from project natural join project_members;
	raise notice 'TOTAL JOIN RECORDS: %', proj_count;
end; 
$$;


ALTER PROCEDURE public.show_projects_join_count_sp() OWNER TO postgres;

--
-- Name: utility_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utility_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utility_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: administrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrator (
    id integer DEFAULT nextval('public.utility_id_seq'::regclass) NOT NULL,
    fullname character varying(100) NOT NULL,
    role character varying(100) NOT NULL
);


ALTER TABLE public.administrator OWNER TO postgres;

--
-- Name: allowance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.allowance (
    allowanceid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.allowance OWNER TO postgres;

--
-- Name: allowance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.allowance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.allowance_id_seq OWNER TO postgres;

--
-- Name: allowance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.allowance_id_seq OWNED BY public.allowance.id;


--
-- Name: data_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_types (
    age smallint NOT NULL,
    empid integer NOT NULL,
    popsize bigint NOT NULL,
    salary double precision NOT NULL,
    accountamount real,
    donation numeric NOT NULL,
    mortgage numeric(10,3) NOT NULL,
    nickname character(10) NOT NULL,
    "position" character varying(200) NOT NULL,
    comment text NOT NULL,
    isemployed boolean NOT NULL,
    timein time without time zone NOT NULL,
    birthday date NOT NULL,
    dateresigned timestamp without time zone NOT NULL,
    moneytxdate timestamp with time zone NOT NULL,
    id integer NOT NULL,
    amount money NOT NULL,
    isturnoff bit(1) NOT NULL
);


ALTER TABLE public.data_types OWNER TO postgres;

--
-- Name: data_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.data_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.data_types_id_seq OWNER TO postgres;

--
-- Name: data_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.data_types_id_seq OWNED BY public.data_types.id;


--
-- Name: developer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.developer (
    id integer NOT NULL,
    employeeid smallint NOT NULL,
    devid integer DEFAULT 1 NOT NULL,
    CONSTRAINT devid CHECK ((devid >= 1))
);


ALTER TABLE public.developer OWNER TO postgres;

--
-- Name: developer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.developer_id_seq OWNER TO postgres;

--
-- Name: developer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;


--
-- Name: insurance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance (
    policyid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.insurance OWNER TO postgres;

--
-- Name: insurance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insurance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insurance_id_seq OWNER TO postgres;

--
-- Name: insurance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insurance_id_seq OWNED BY public.insurance.id;


--
-- Name: manager_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manager_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manager_id_seq OWNER TO postgres;

--
-- Name: manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manager (
    id integer DEFAULT nextval('public.manager_id_seq'::regclass) NOT NULL,
    firstname character varying(100) NOT NULL,
    gender character(1) DEFAULT 'F'::bpchar NOT NULL,
    age integer NOT NULL,
    salary double precision NOT NULL,
    birthday date NOT NULL,
    supervisors text,
    CONSTRAINT manager_age_check CHECK ((age >= 0)),
    CONSTRAINT manager_birthday_check CHECK ((birthday >= '1920-01-01'::date))
);


ALTER TABLE public.manager OWNER TO postgres;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    id smallint NOT NULL,
    projname character varying(200) NOT NULL,
    projdate date NOT NULL
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: project_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_members (
    empid integer NOT NULL,
    firstname character varying(60) NOT NULL,
    lastname character varying(60) NOT NULL,
    projid integer NOT NULL
);


ALTER TABLE public.project_members OWNER TO postgres;

--
-- Name: project_data_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.project_data_view AS
 SELECT a.id,
    a.projname,
    a.projdate,
    b.empid,
    b.firstname,
    b.lastname,
    b.projid
   FROM (public.project a
     CROSS JOIN public.project_members b);


ALTER VIEW public.project_data_view OWNER TO postgres;

--
-- Name: stocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stocks (
    id smallint NOT NULL,
    commision double precision,
    rate double precision,
    amount double precision DEFAULT 1.0 NOT NULL
);


ALTER TABLE public.stocks OWNER TO postgres;

--
-- Name: utility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utility (
    id integer DEFAULT nextval('public.utility_id_seq'::regclass) NOT NULL,
    fullname character varying(100) NOT NULL
);


ALTER TABLE public.utility OWNER TO postgres;

--
-- Name: allowance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowance ALTER COLUMN id SET DEFAULT nextval('public.allowance_id_seq'::regclass);


--
-- Name: data_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_types ALTER COLUMN id SET DEFAULT nextval('public.data_types_id_seq'::regclass);


--
-- Name: developer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);


--
-- Name: insurance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance ALTER COLUMN id SET DEFAULT nextval('public.insurance_id_seq'::regclass);


--
-- Data for Name: administrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrator (id, fullname, role) FROM stdin;
4	James Reid	CEO
6	John	CEO
8	John Chua	CEO
10	John Chua	CEO
\.


--
-- Data for Name: allowance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.allowance (allowanceid, id) FROM stdin;
1	1
2	2
\.


--
-- Data for Name: data_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_types (age, empid, popsize, salary, accountamount, donation, mortgage, nickname, "position", comment, isemployed, timein, birthday, dateresigned, moneytxdate, id, amount, isturnoff) FROM stdin;
\.


--
-- Data for Name: developer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.developer (id, employeeid, devid) FROM stdin;
\.


--
-- Data for Name: insurance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurance (policyid, id) FROM stdin;
\.


--
-- Data for Name: manager; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager (id, firstname, gender, age, salary, birthday, supervisors) FROM stdin;
105	Lorna	F	220	99000	1929-10-10	102
104	Honggoy	M	120	60000	1999-10-10	102
106	Jose	M	98	10000	1929-10-10	102
103	Pilar	F	70	60000	2019-10-10	101
107	Apo	M	70	60000	2019-10-10	101
102	Mark	M	32	100000	1929-10-10	101
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (id, projname, projdate) FROM stdin;
2	credit card app	2025-03-25
3	DTR System	2025-05-05
4	scanner	2030-12-25
5	E-Cart	2026-10-20
6	Home Credit	2026-10-20
\.


--
-- Data for Name: project_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_members (empid, firstname, lastname, projid) FROM stdin;
101	Juan	Luna	2
102	Maria	Clara	2
104	Apo	Mabini	3
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stocks (id, commision, rate, amount) FROM stdin;
1	\N	\N	10
2	500	0.1	10
3	1000	0.2	1000
\.


--
-- Data for Name: utility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utility (id, fullname) FROM stdin;
1	Alice
2	James Reid
3	James Reid
5	James Reid
7	James Reid
9	James Reid
\.


--
-- Name: allowance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.allowance_id_seq', 1, false);


--
-- Name: data_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_types_id_seq', 1, false);


--
-- Name: developer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.developer_id_seq', 1, false);


--
-- Name: insurance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insurance_id_seq', 1, false);


--
-- Name: manager_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manager_id_seq', 1, false);


--
-- Name: utility_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utility_id_seq', 10, true);


--
-- Name: administrator administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);


--
-- Name: allowance allowance_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowance
    ADD CONSTRAINT allowance_id_key UNIQUE (id);


--
-- Name: allowance allowance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowance
    ADD CONSTRAINT allowance_pkey PRIMARY KEY (allowanceid);


--
-- Name: developer developer_empid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_empid_key UNIQUE (employeeid);


--
-- Name: developer developer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);


--
-- Name: data_types empid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT empid UNIQUE (empid);


--
-- Name: insurance insurance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_pkey PRIMARY KEY (policyid, id);


--
-- Name: manager manager_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_pkey PRIMARY KEY (empid);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: utility utility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utility
    ADD CONSTRAINT utility_pkey PRIMARY KEY (id);


--
-- Name: developer developer_devid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_devid_fkey FOREIGN KEY (devid) REFERENCES public.manager(id);


--
-- Name: project_members project_members_projid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_projid_fkey FOREIGN KEY (projid) REFERENCES public.project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

