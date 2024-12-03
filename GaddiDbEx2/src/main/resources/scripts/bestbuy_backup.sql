--
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
-- Name: insert_customer_sp(character varying, character varying, numeric, numeric, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_customer_sp(IN cust_name character varying, IN city character varying, IN grade numeric, IN salesman_id numeric, INOUT is_success boolean)
    LANGUAGE plpgsql
    AS $$ 
begin
    begin
        insert into customer (CUST_NAME, CITY, GRADE, SALESMAN_ID)
        values(CUST_NAME, CITY, GRADE, SALESMAN_ID);
        is_success := true;
        raise notice 'CUSTOMER INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;


ALTER PROCEDURE public.insert_customer_sp(IN cust_name character varying, IN city character varying, IN grade numeric, IN salesman_id numeric, INOUT is_success boolean) OWNER TO postgres;

--
-- Name: insert_orders_sp(numeric, date, numeric, numeric, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_orders_sp(IN purch_amt numeric, IN ord_date date, IN customer_id numeric, IN salesman_id numeric, INOUT is_success boolean)
    LANGUAGE plpgsql
    AS $$ 
begin
    begin
        insert into orders (PURCH_AMT, ORD_DATE, CUSTOMER_ID, SALESMAN_ID)
        values(PURCH_AMT, ORD_DATE, CUSTOMER_ID, SALESMAN_ID);
        is_success := true;
        raise notice 'ORDER INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;


ALTER PROCEDURE public.insert_orders_sp(IN purch_amt numeric, IN ord_date date, IN customer_id numeric, IN salesman_id numeric, INOUT is_success boolean) OWNER TO postgres;

--
-- Name: insert_salesman_sp(character varying, character varying, numeric, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_salesman_sp(IN name character varying, IN city character varying, IN coms numeric, INOUT is_success boolean)
    LANGUAGE plpgsql
    AS $$ 
begin
    begin
        insert into salesman (NAME, CITY, COMMISSION)
        values(name, city, coms);
        is_success := true;
        raise notice 'SALESMAN INSERTED';
    exception
        when others then
            is_success := false;
            raise notice 'INSERT FAILED: %', sqlerrm;
    end;
end; 
$$;


ALTER PROCEDURE public.insert_salesman_sp(IN name character varying, IN city character varying, IN coms numeric, INOUT is_success boolean) OWNER TO postgres;

--
-- Name: customer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_seq
    START WITH 3001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id numeric(5,0) DEFAULT nextval('public.customer_seq'::regclass) NOT NULL,
    cust_name character varying(30) NOT NULL,
    city character varying(15) NOT NULL,
    grade numeric(3,0),
    salesman_id numeric(5,0) NOT NULL
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: order_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_seq
    START WITH 70001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_seq OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    ord_no numeric(5,0) DEFAULT nextval('public.order_seq'::regclass) NOT NULL,
    purch_amt numeric(8,2) NOT NULL,
    ord_date date NOT NULL,
    customer_id numeric(5,0) NOT NULL,
    salesman_id numeric(5,0) NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orderspurchase_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.orderspurchase_view AS
 SELECT min(purch_amt) AS min_purchase_amt
   FROM public.orders;


ALTER VIEW public.orderspurchase_view OWNER TO postgres;

--
-- Name: salesman_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salesman_seq
    START WITH 5001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salesman_seq OWNER TO postgres;

--
-- Name: salesman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salesman (
    salesman_id numeric(5,0) DEFAULT nextval('public.salesman_seq'::regclass) NOT NULL,
    name character varying(30) NOT NULL,
    city character varying(15) NOT NULL,
    commission numeric(10,2) NOT NULL
);


ALTER TABLE public.salesman OWNER TO postgres;

--
-- Name: salesmensamecity_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.salesmensamecity_view AS
 SELECT s.name AS salesman_name,
    c.cust_name AS customer_name,
    s.city
   FROM (public.salesman s
     JOIN public.customer c USING (salesman_id, city))
  WHERE ((s.city)::text = (c.city)::text);


ALTER VIEW public.salesmensamecity_view OWNER TO postgres;

--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (customer_id, cust_name, city, grade, salesman_id) FROM stdin;
3001	rad Guzan	London	\N	5005
3002	Nick Rimando	New York	100	5001
3003	Jozy Altidor	Moscow	200	5007
3004	Fabian Johnson	Paris	300	5006
3005	Graham Zusi	California	200	5002
3007	Brad Davis	New York	200	5001
3008	Julian Green	London	300	5002
3009	Geoff Cameron	Berlin	100	5003
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) FROM stdin;
70001	150.50	2012-10-05	3005	5002
70002	65.26	2012-10-05	3002	5001
70003	2480.40	2012-10-10	3009	5003
70004	110.50	2012-08-17	3009	5003
70005	2400.60	2012-07-27	3007	5001
70007	948.50	2012-09-10	3005	5002
70008	5760.00	2012-09-10	3002	5001
70009	270.65	2012-09-10	3001	5005
70010	1983.43	2012-10-10	3004	5006
70011	75.29	2012-08-17	3003	5007
70012	250.45	2012-06-27	3008	5002
70013	3045.60	2012-04-25	3002	5001
\.


--
-- Data for Name: salesman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salesman (salesman_id, name, city, commission) FROM stdin;
5001	James Hoog	New York	0.15
5002	Nail Knite	Paris	0.13
5003	Lauson Hen	San Jose	0.12
5005	Pit Alex	London	0.11
5006	Mc Lyon	Paris	0.14
5007	Paul Adam	Rome	0.13
\.


--
-- Name: customer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_seq', 3009, true);


--
-- Name: order_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_seq', 70013, true);


--
-- Name: salesman_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salesman_seq', 5007, true);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (ord_no);


--
-- Name: salesman salesman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salesman
    ADD CONSTRAINT salesman_pkey PRIMARY KEY (salesman_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_salesman_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_salesman_id_fkey FOREIGN KEY (salesman_id) REFERENCES public.salesman(salesman_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

