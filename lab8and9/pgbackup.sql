--
-- PostgreSQL database cluster dump
--

-- Started on 2015-11-20 10:52:11

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

--CREATE ROLE postgres;
--ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md559101864da981a96b2b6287dc84da014';






--
-- Database creation
--

CREATE DATABASE book WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect book

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta2
-- Dumped by pg_dump version 9.5beta2

-- Started on 2015-11-20 10:52:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 191 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2283 (class 0 OID 0)
-- Dependencies: 191
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 192 (class 3079 OID 16482)
-- Name: cube; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- TOC entry 2284 (class 0 OID 0)
-- Dependencies: 192
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- TOC entry 195 (class 3079 OID 16415)
-- Name: dict_xsyn; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dict_xsyn WITH SCHEMA public;


--
-- TOC entry 2285 (class 0 OID 0)
-- Dependencies: 195
-- Name: EXTENSION dict_xsyn; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dict_xsyn IS 'text search dictionary template for extended synonym processing';


--
-- TOC entry 194 (class 3079 OID 16420)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 2286 (class 0 OID 0)
-- Dependencies: 194
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 193 (class 3079 OID 16431)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 2287 (class 0 OID 0)
-- Dependencies: 193
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 196 (class 3079 OID 16394)
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- TOC entry 2288 (class 0 OID 0)
-- Dependencies: 196
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET search_path = public, pg_catalog;

--
-- TOC entry 286 (class 1255 OID 16614)
-- Name: add_event(text, timestamp without time zone, timestamp without time zone, text, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_event(title text, starts timestamp without time zone, ends timestamp without time zone, venue text, postal character varying, country character) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ DECLARE did_insert boolean := false;
found_count integer;
 the_venue_id integer;
BEGIN 
SELECT venue_id INTO the_venue_id FROM venues v WHERE v.postal_code=postal AND v.country_code=country AND v.name ILIKE venue LIMIT 1; 
IF the_venue_id IS NULL THEN INSERT INTO venues (name, postal_code, country_code) VALUES (venue, postal, country) RETURNING venue_id INTO the_venue_id; 
did_insert := true; 
END IF; 
  -- Note: not an "error", as in some programming languages
RAISE NOTICE 'Venue found %', the_venue_id;
INSERT INTO events (title, starts, ends, venue_id)  VALUES (title, starts, ends, the_venue_id); 
RETURN did_insert;
END; 
 
$$;


ALTER FUNCTION public.add_event(title text, starts timestamp without time zone, ends timestamp without time zone, venue text, postal character varying, country character) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 16619)
-- Name: log_event(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION log_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ DECLARE
BEGIN 
INSERT INTO logs (event_id, old_title, old_starts, old_ends) VALUES (OLD.event_id, OLD.title, OLD.starts, OLD.ends);
RAISE NOTICE 'Someone just changed event #%', OLD.event_id; RETURN NEW; 
END;
$$;


ALTER FUNCTION public.log_event() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 184 (class 1259 OID 16564)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cities (
    name text NOT NULL,
    postal_code character varying(9) NOT NULL,
    country_code character(2) NOT NULL,
    CONSTRAINT cities_postal_code_check CHECK (((postal_code)::text <> ''::text))
);


ALTER TABLE cities OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16554)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE countries (
    country_code character(2) NOT NULL,
    country_name text
);


ALTER TABLE countries OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16600)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE events (
    event_id integer NOT NULL,
    title character varying(30),
    starts timestamp without time zone,
    ends timestamp without time zone,
    venue_id integer NOT NULL
);


ALTER TABLE events OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16596)
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE events_event_id_seq OWNER TO postgres;

--
-- TOC entry 2289 (class 0 OID 0)
-- Dependencies: 187
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE events_event_id_seq OWNED BY events.event_id;


--
-- TOC entry 188 (class 1259 OID 16598)
-- Name: events_venue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE events_venue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE events_venue_id_seq OWNER TO postgres;

--
-- TOC entry 2290 (class 0 OID 0)
-- Dependencies: 188
-- Name: events_venue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE events_venue_id_seq OWNED BY events.venue_id;


--
-- TOC entry 190 (class 1259 OID 16615)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logs (
    event_id integer,
    old_title character varying(255),
    old_starts timestamp without time zone,
    old_ends timestamp without time zone,
    logged_at timestamp without time zone DEFAULT now()
);


ALTER TABLE logs OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16580)
-- Name: venues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE venues (
    venue_id integer NOT NULL,
    name character varying(255),
    street_address text,
    type character(7) DEFAULT 'public'::bpchar,
    postal_code character varying(9),
    country_code character(2),
    CONSTRAINT venues_type_check CHECK ((type = ANY (ARRAY['public'::bpchar, 'private'::bpchar])))
);


ALTER TABLE venues OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16578)
-- Name: venues_venue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE venues_venue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE venues_venue_id_seq OWNER TO postgres;

--
-- TOC entry 2291 (class 0 OID 0)
-- Dependencies: 185
-- Name: venues_venue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE venues_venue_id_seq OWNED BY venues.venue_id;


--
-- TOC entry 2135 (class 2604 OID 16603)
-- Name: event_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY events ALTER COLUMN event_id SET DEFAULT nextval('events_event_id_seq'::regclass);


--
-- TOC entry 2136 (class 2604 OID 16604)
-- Name: venue_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY events ALTER COLUMN venue_id SET DEFAULT nextval('events_venue_id_seq'::regclass);


--
-- TOC entry 2132 (class 2604 OID 16583)
-- Name: venue_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY venues ALTER COLUMN venue_id SET DEFAULT nextval('venues_venue_id_seq'::regclass);


--
-- TOC entry 2269 (class 0 OID 16564)
-- Dependencies: 184
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cities (name, postal_code, country_code) FROM stdin;
Portland	97205	us
\.


--
-- TOC entry 2268 (class 0 OID 16554)
-- Dependencies: 183
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY countries (country_code, country_name) FROM stdin;
us	United States
mx	Mexico
au	Australia
gb	United Kingdom
de	Germany
\.


--
-- TOC entry 2274 (class 0 OID 16600)
-- Dependencies: 189
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY events (event_id, title, starts, ends, venue_id) FROM stdin;
1	LARP Club	2012-02-15 17:30:00	2012-02-15 19:30:00	2
2	April Fools Day	2012-02-15 17:30:00	2012-02-15 19:30:00	1
3	Christmas Day	2012-02-15 17:30:00	2012-02-15 19:30:00	2
4	Easter	2012-02-15 17:30:00	2012-02-15 19:30:00	1
5	House Party	2012-05-03 23:00:00	2012-05-04 01:00:00	3
\.


--
-- TOC entry 2292 (class 0 OID 0)
-- Dependencies: 187
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('events_event_id_seq', 5, true);


--
-- TOC entry 2293 (class 0 OID 0)
-- Dependencies: 188
-- Name: events_venue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('events_venue_id_seq', 1, true);


--
-- TOC entry 2275 (class 0 OID 16615)
-- Dependencies: 190
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logs (event_id, old_title, old_starts, old_ends, logged_at) FROM stdin;
5	House Party	2012-05-03 23:00:00	2012-05-04 02:00:00	2015-11-20 10:46:12.415418
\.


--
-- TOC entry 2271 (class 0 OID 16580)
-- Dependencies: 186
-- Data for Name: venues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY venues (venue_id, name, street_address, type, postal_code, country_code) FROM stdin;
1	Crystal Ballroom	\N	public 	97205	us
2	Voodoo Donuts	\N	public 	97205	us
3	Run's House	\N	public 	97205	us
\.


--
-- TOC entry 2294 (class 0 OID 0)
-- Dependencies: 185
-- Name: venues_venue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('venues_venue_id_seq', 3, true);


--
-- TOC entry 2143 (class 2606 OID 16572)
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (country_code, postal_code);


--
-- TOC entry 2139 (class 2606 OID 16563)
-- Name: countries_country_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_country_name_key UNIQUE (country_name);


--
-- TOC entry 2141 (class 2606 OID 16561)
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_code);


--
-- TOC entry 2147 (class 2606 OID 16606)
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2145 (class 2606 OID 16590)
-- Name: venues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (venue_id);


--
-- TOC entry 2148 (class 1259 OID 16613)
-- Name: events_starts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_starts ON events USING btree (starts);


--
-- TOC entry 2149 (class 1259 OID 16612)
-- Name: events_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX events_title ON events USING hash (title);


--
-- TOC entry 2153 (class 2620 OID 16620)
-- Name: log_events; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER log_events AFTER UPDATE ON events FOR EACH ROW EXECUTE PROCEDURE log_event();


--
-- TOC entry 2150 (class 2606 OID 16573)
-- Name: cities_country_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_country_code_fkey FOREIGN KEY (country_code) REFERENCES countries(country_code);


--
-- TOC entry 2152 (class 2606 OID 16607)
-- Name: events_venue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES venues(venue_id);


--
-- TOC entry 2151 (class 2606 OID 16591)
-- Name: venues_country_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY venues
    ADD CONSTRAINT venues_country_code_fkey FOREIGN KEY (country_code, postal_code) REFERENCES cities(country_code, postal_code) MATCH FULL;


--
-- TOC entry 2282 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-11-20 10:52:11

--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta2
-- Dumped by pg_dump version 9.5beta2

-- Started on 2015-11-20 10:52:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2095 (class 1262 OID 12373)
-- Dependencies: 2094
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 181 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2098 (class 0 OID 0)
-- Dependencies: 181
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 180 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2099 (class 0 OID 0)
-- Dependencies: 180
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-11-20 10:52:11

--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta2
-- Dumped by pg_dump version 9.5beta2

-- Started on 2015-11-20 10:52:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2094 (class 1262 OID 1)
-- Dependencies: 2093
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- TOC entry 180 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 180
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-11-20 10:52:12

--
-- PostgreSQL database dump complete
--

-- Completed on 2015-11-20 10:52:12

--
-- PostgreSQL database cluster dump complete
--

